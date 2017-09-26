#-*- mode: ruby; coding: utf-8 -*-


module ModulePlus
  module Exception
    class NotImplemented        < StandardError ; end
    class CouldNotWrite         < StandardError ; end
    class NotPermittedToInclude < StandardError ; end
    class NotPermittedToExtend  < StandardError ; end
    class NotInitializedYet     < StandardError ; end
  end
end

include ModulePlus::Exception
