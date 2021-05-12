require 'capybara/rails'

class CovsaxController < ApplicationController
  include Capybara::DSL

  ALL_IMPFCENTERS = [
    'Dippoldiswalde',
    'Freital',
    'Belgern-Schildau',
    'Borna',
    'Kamenz',
    'Chemnitz',
    'Dresden',
    'Treuen',
    'Annaberg-Buchholz',
    'Grimma',
    'Löbau',
    'Leipzig',
    'Mittweida',
    'Plauen',
    'Pirna',
    'Riesa',
    'Zwickau'
  ]

  def index
    @max_minutes      = 600
    @cycle_minutes    = 2
    @impfcenters      = {}
  end

  def lookup_for_appointment
    begin
      session = nil                                                             # allows close in exception handler
      @link_url         = params[:link_url]
      @password         = params[:password]
      @max_minutes      = params[:max_minutes].to_i
      @cycle_minutes    = params[:cycle_minutes].to_i
      @impfcenters      = {}
      1.upto(10) do |ic|
        @impfcenters[ic] = params["impfcenter_#{ic}"] if params["impfcenter_#{ic}"] != '[KEINES]'
      end

      Rails.logger.debug "Start Terminsuche für #{@max_minutes} Minuten mit #{@cycle_minutes} Minuten zwischen den Versuchen"

      @message = 'Keine Information gefunden'                                                    # For display in template
      raise "Zeit zwischen den Versuchen (#{@cycle_minutes}) muss > 0 sein" if @cycle_minutes <= 0
      raise "Max. Suchzeit (#{@max_minutes}) muss größer sein als Zeit zwischen den Versuchen (#{@cycle_minutes})" if @max_minutes <= @cycle_minutes

      max_cycle_count = @max_minutes / @cycle_minutes
      cycle_count = 0
      while cycle_count < max_cycle_count do
        cycle_count += 1

        Capybara.current_driver = :selenium_chrome
        Capybara.app_host = @link_url
        visit @link_url
        if page.has_content?('Aufgrund der vielen Anfragen')
          Rails.logger.debug "Seite überlastet, Ende des Versuchs"
        else
          if page.has_content?('Zugang')
            find_field(type: 'password').set(@password)
            find_button('Weiter').click
            wait_for_content_successful 'Bitte geben Sie an, wie Sie fortfahren möchten'
            radiobuttons = all('.gwt-RadioButton')
            raise "Radiobuttons nicht gefunden für fortfahren" if radiobuttons.count == 0
            radiobuttons[0].click
            sleep(2)
            find_button('Weiter').click
            wait_for_content_successful 'Terminfindung'

            @impfcenters.keys.sort.each do |k|
              if impfcenter_available?(@impfcenters[k])
                @message = "Termin gefunden für '#{@impfcenters[k]}'! Bitte eigenständig weiter machen."
                Rails.logger.debug @message
                return
              end
            end
          else
            sleep 10                                                            # Allow recognition of page
            page.save_screenshot('/tmp/zugang.png', full: true)
            raise "Seite zeigt weder Zugangsdaten noch überlastet"
          end
        end
        sleep(2)
        page.quit
        sleep @cycle_minutes * 60
      end
      @message = "Kein Termin gefunden nach #{cycle_count} Versuchen!"
    rescue Exception => e
      Rails.logger.error "#{e.class}: #{e.message}"
      e.backtrace.each do |bt|
        Rails.logger.error bt
      end

      sleep(2)
      page&.save_screenshot('/tmp/exception.png', full: true)
      page&.quit
      @message = "<span style='background-color: lightyellow; color:red'>Fehler: #{e.message}</span>".html_safe
    ensure
      Rails.logger.debug "Ende Terminsuche für #{@max_minutes} Minuten mit #{@cycle_minutes} Minuten zwischen den Versuchen"
    end
  end

  private
  def impfcenter_available?(impfcenter)
    Rails.logger.debug "Suche Termin für #{impfcenter}"
    selects = all('span.select2')
    raise "Selects nicht gefunden für fortfahren" if selects.count == 0
    selects[0].click                                                            # Klick in Auswahl Impfcenter

    search_fields = all('input.select2-search__field')
    raise "Search Input nicht gefunden für fortfahren" if search_fields.count == 0
    search_fields[0].set(impfcenter)
    sleep 2
    search_fields[0].native.send_keys(:return)
    find_button('Weiter').click
    wait_for_content_successful 'Termin'
    sleep 2                                                                     # Evtl. ist "Termin" bereits in vorheriger Seite enthalten
    if page.has_content? 'wir Ihnen leider'                                     # "keinen Termin" steht erst nach Linefeed
      sleep(2)
      page&.save_screenshot('/tmp/keinen_termin_gefunden.png', full: true)
      find_button('Zurück').click
      Rails.logger.debug "Kein Termin gefunden für #{impfcenter}"
      false
    else
      page&.save_screenshot('/tmp/termin_gefunden.png', full: true)
      Rails.logger.debug "Termin gefunden für #{impfcenter}"
      true
    end
  end

  def wait_for_content_successful(search_string)
    loop_count = 0
    while loop_count < 10 do
      loop_count += 1
      return if page.has_content? search_string
      sleep 1
    end
    raise "Gesuchter Inhalt auf Seite nicht gefunden: #{search_string}"
  end

end
