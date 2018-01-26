#-*- mode: ruby; coding: utf-8 -*-


#
# refer activesupport
#
# https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/deep_merge.rb
#

module ModulePlus
  module CoreExt
    module Hash

      def deep_merge(other_hash, &block)
        dup.deep_merge!(other_hash, &block)
      end

      # Same as +deep_merge+, but modifies +self+.
      def deep_merge!(other_hash, &block)
        merge!(other_hash) do |key, this_val, other_val|
          if this_val.is_a?(Hash) && other_val.is_a?(Hash)
            this_val.deep_merge(other_val, &block)
          elsif block_given?
            block.call(key, this_val, other_val)
          else
            other_val
          end
        end
      end
    end
  end
end

class Hash
  include ModulePlus::CoreExt::Hash
end
