module Grape
  module Validations
    class ParamsScope
      # @return [String] the proper attribute name, with nesting considered.
      def full_name(name)
        message = nil
        case
        when nested?
          # Find our containing element's name, and append ours.
          message = "#{@parent.full_name(@element)}#{parent_index}[#{name}]"
        when lateral?
          # Find the name of the element as if it was at the
          # same nesting level as our parent.
          message = @parent.full_name(name)
        else
          # We must be the root scope, so no prefix needed.
          message = name.to_s
        end
        message = message.gsub(/_|\./, ' ')
      end
    end
  end
end

# module Grape
#   module Validations
#     class ParamsScope
#       # @return [String] the proper attribute name, with nesting considered.
#       def full_name(name)
#         message = nil
#         case
#         when nested?
#           # Find our containing element's name, and append ours.
#           message = "#{@parent.full_name(@element).capitalize} #{name}"
#         when lateral?
#           # Find the name of the element as if it was at the
#           # same nesting level as our parent.
#           message = @parent.full_name(name).capitalize
#         else
#           # We must be the root scope, so no prefix needed.
#           message = name.to_s
#         end
#         message = message.gsub(/_|\./, ' ')
#       end
#     end
#   end
# end
