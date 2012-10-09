require "shellutils/version"
require "thor"

module ShellUtils

  @@color = Thor::Shell::Color.new

  def self.exec_cmd_and_clear_password(cmd)
    say(cmd, :green)
    PTY.spawn(cmd) do |r, w|
      w.sync = true
      expect_result = r.expect(/[Pp]assword.*:.*$/)
      if expect_result
        w.puts(get_sudo_pw)
      end
      puts "-> ok"
      w.flush              
      begin                
        puts r.read        
      rescue Errno::EIO # GNU/Linux raises EIO.
      end
    end
  end
    
  def self.sudo(cmd)
    exec_cmd_and_clear_password("sudo #{cmd}")
  end
  
  def self.rvmsudo(cmd)
    exec_cmd_and_clear_password("rvmsudo #{cmd}")
  end

  def self.sh(cmd)
    say(cmd, :green)
    `#{cmd}`
  end

  def self.say(cmd, color=nil)
    puts @@color.set_color(cmd, color)
  end
end
