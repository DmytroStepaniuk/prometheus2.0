module RPMFile
  class Source < Base
    def filename
      "#{ name }-#{ version }-#{ release }.src.rpm"
    end
  end
end
