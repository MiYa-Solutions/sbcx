module Abstract
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def abstract_methods(*args)
      args.each do |name|
        class_eval(<<-END, __FILE__, __LINE__)
          def #{name}(*args)
            raise NotImplementedError.new("You must implement #{name}.")
          end
        END

      end
    end
  end
end
