require 'spec_helper'

module ShellUtils
  describe ShellUtils do
    it "shoudl exec shell command" do
      ShellUtils.sh "pwd"
    end
    
  end


end
