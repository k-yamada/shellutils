# encoding: UTF-8  

require 'thor'
require 'timeout'
require 'pty'
require 'expect'

module ShellUtils
  SUDO_PWD_PATH = ".sudo_pwd"

  class << self

    @@color = Thor::Shell::Color.new

    def say(cmd, color=nil)
      puts @@color.set_color(cmd, color)
    end

    def sh(cmd)
      say(cmd, :green)
      `#{cmd}`
    end

    def file_write(filepath, str)
      File.open(filepath, "w") {|f| f.write str}
    end

    def file_read(filepath)
      File.open(filepath) {|f| f.read}
    end

    def is_linux?
      return true if `uname` =~ /Linux/
      false
    end
    
    def is_mac?
      return true if `uname` =~ /Darwin/
      false
    end
    
    def get_platform
      if is_linux?
        'linux'
      elsif is_mac?
        'macos'
      else 
        'unknown'
      end
    end
  
    def is_installed?(program)
      `which #{program}`.chomp != ""
    end
  
    def get_sudo_pwd
      if File.exist?(SUDO_PWD_PATH) == false || file_read(SUDO_PWD_PATH) == ""
        pw = user_input("please input sudo password")
        set_sudo_pwd(pw)
      end
      file_read(SUDO_PWD_PATH)
    end
  
    def set_sudo_pwd(pw)
      file_write(SUDO_PWD_PATH, pw)
    end
    
    def user_input(desc, example = nil, choices = nil)
      if example
        puts "#{desc}: ex) #{example}"
      elsif choices
        puts "#{desc}: [#{choices.join("|")}]"
      else
        puts "#{desc}:"
      end
      print ">>"
      input = STDIN.gets.chomp
      while choices && !choices.include?(input)
        puts "The value you entered is incorrect(#{input}). Please re-enter"
        print ">>"
        input = STDIN.gets.chomp
      end
      input
    end
  
    def make_file_from_template(template_path, dest_path, hash)
      puts "create #{dest_path}"
      template = ERB.new File.read(template_path)
      open(dest_path, "w") do |f|
        binded_txt = template.result binding
        f.puts binded_txt
      end
    end

    def error(msg)
      STDERR.puts @@color.set_color("### ERROR:#{msg}", :red)
      raise
    end
  
    def current_method(index = 0)
      caller[index].scan(/`(.*)'/).flatten.to_s
    end
   
    def exec_cmd_and_clear_password(cmd)
      puts cmd
      PTY.spawn(cmd) do |r, w|
        w.sync = true
        if r.expect(/[Pp]assword.*:.*$/)
          w.puts(get_sudo_pwd)
          if r.expect(/[Pp]assword.*:.*$/)
            error("the sudo password is incorrect. password=#{get_sudo_pwd}\nPlease change the password ex) set_sudo_pwd PASSWORD")
          end
        end
        puts "-> ok"
        w.flush              
        begin                
          puts r.read        
        rescue Errno::EIO # GNU/Linux raises EIO.
        end
      end
    end
    
    def sudo(cmd)
      exec_cmd_and_clear_password("sudo #{cmd}")
    end
    
    def rvmsudo(cmd)
      exec_cmd_and_clear_password("rvmsudo #{cmd}")
    end
  
  end
end # ShellUtils

