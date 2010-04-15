module Hcache

  class Command

    def initialize(args, cache_dir, gcc_default_includes, remove_o=false,
                   insert_args="")
      @command = rewrite(args, cache_dir, gcc_default_includes, remove_o,
                         insert_args)
    end

    def rewrite(args, cache_dir, gcc_default_includes, remove_o, insert_args)
      argv = args.clone
      command = "#{argv.shift} "
      new_includes = gcc_default_includes
      old_includes = ""
      while !new_includes.empty? do
        include_dir = new_includes.shift
        command += "-I#{cache_dir}#{include_dir} "
      end
      while !argv.empty? do
        arg = argv.shift
        if arg.match(/^\-I/)
          include_dir = arg[2, arg.length]
          command += "-I#{cache_dir}#{include_dir} "
          old_includes += "-I#{include_dir} "
        elsif arg == "-o" and remove_o
          argv.shift
        else
          command += "#{arg} "    
        end
      end
      command += "#{insert_args} #{old_includes}"
      command
    end

    def to_s
      @command
    end

  end

end

