require 'msf/core'

class DumpBrowserProfiles < Msf::Plugin

  # This function will be called when the plugin is loaded
  def initialize(framework, opts)
    super

    add_console_dispatcher(BrowserProfileCommandDispatcher)
    print_line("DumpBrowserProfiles plugin loaded.")
    print_line("Available commands:")
    print_line("  dump_chrome - Dumps the Google Chrome profile")
    print_line("  dump_firefox - Dumps the Mozilla Firefox profile")
    print_line("  dump_edge - Dumps the Microsoft Edge profile")
    print_line("  dump_opera - Dumps the Opera profile")
  end

  # This function will be called when the plugin is unloaded
  def cleanup
    remove_console_dispatcher('BrowserProfileCommandDispatcher')
    print_line("DumpBrowserProfiles plugin unloaded.")
  end

  class BrowserProfileCommandDispatcher
    include Msf::Ui::Console::CommandDispatcher

    def name
      'BrowserProfileCommandDispatcher'
    end

    def commands
      {
        'dump_chrome' => 'Dump the Google Chrome profile',
        'dump_firefox' => 'Dump the Mozilla Firefox profile',
        'dump_edge' => 'Dump the Microsoft Edge profile',
        'dump_opera' => 'Dump the Opera profile'
      }
    end

    def dump_profile(browser_name, source_path)
      dest_path = "#{ENV['USERPROFILE']}\\Dumped_#{browser_name}_Profile"
      if File.exist?(source_path)
        print_line("Copying profile from #{source_path} to #{dest_path}")
        ::FileUtils.cp_r(source_path, dest_path, remove_destination: true)
        print_line("Profile dump complete.")
      else
        print_line("Source path #{source_path} does not exist.")
      end
    end

    def cmd_dump_chrome
      source_path = "#{ENV['LOCALAPPDATA']}\\Google\\Chrome\\User Data"
      dump_profile('Chrome', source_path)
    end

    def cmd_dump_firefox
      source_path = "#{ENV['APPDATA']}\\Mozilla\\Firefox\\Profiles"
      dump_profile('Firefox', source_path)
    end

    def cmd_dump_edge
      source_path = "#{ENV['LOCALAPPDATA']}\\Microsoft\\Edge\\User Data"
      dump_profile('Edge', source_path)
    end

    def cmd_dump_opera
      source_path = "#{ENV['APPDATA']}\\Opera Software\\Opera Stable"
      dump_profile('Opera', source_path)
    end
  end
end

DumpBrowserProfiles
