module Log4r
  class YamlConfigurator
    # Given a filename, loads the YAML configuration for Log4r.
    def self.load_yaml_files(filenames, yaml_sections = ['log4r_config'])
      cfgs = []
      yaml_sections.each do |yaml_section|
        filenames.each do |filename|
          log4r_config = nil
          docs = File.open(filename)
          begin
            YAML.load_documents(docs) do |doc|
              doc.has_key?(yaml_section) and log4r_config = doc[yaml_section] and break
            end
          rescue Exception => e
            raise "YAML error, file: #{filename}, error=#{e.message}"
          end
          if log4r_config
            cfgs << log4r_config
          end
        end
      end

      cfgs.each do |cfg|
        decode_pre_config(cfg['pre_config']) unless cfg['pre_config'].nil?
      end

      cfgs.each do |cfg|
        cfg['outputters'].each{ |op| decode_outputter(op)} unless cfg['outputters'].nil?
      end

      cfgs.each do |cfg|
        cfg['loggers'].each{ |lo| decode_logger(lo)} unless cfg['loggers'].nil?
      end

      cfgs.each do |cfg|
        cfg['logserver'].each{ |lo| decode_logserver(lo)} unless cfg['logserver'].nil?
      end
    end

    def self.decode_pre_config(pre)
      return Logger.root if pre.nil?
      decode_custom_levels( pre['custom_levels'])
      global_config( pre['global'])
      root_config( pre['root'])
      decode_parameters( pre['parameters'])
    end

    def self.root_config(e)
      return if e.nil?
      globlev = e['level']
      return if globlev.nil?
      lev = LNAMES.index(globlev)     # find value in LNAMES
      Log4rTools.validate_level(lev, 4)  # choke on bad level
      Logger.root.level = lev
    end

    def self.decode_logger(lo)
      if lo['name'] == 'root'
        l = Logger.root
      elsif lo['name'] == 'global'
        l = Logger.global
      else
        l = Logger.new lo['name']
      end
      decode_logger_common(l, lo)
    end
  end
end