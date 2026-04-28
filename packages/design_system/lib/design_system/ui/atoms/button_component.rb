module DesignSystem
  module UI
    module Atoms
      # Atomic button component supporting links and native buttons.
      class ButtonComponent < DesignSystem::UI::Component
        VARIANTS = %i[primary secondary ghost link danger].freeze
        SIZES = %i[sm md lg].freeze

        def initialize(
          label:,
          variant: :primary,
          size: :md,
          type: :button,
          href: nil,
          disabled: false,
          aria_label: nil,
          classes: nil
        )
          @label = label
          @variant = normalize_variant(variant)
          @size = normalize_size(size)
          @type = type
          @href = href
          @disabled = disabled
          @aria_label = aria_label
          @classes = classes
        end

        def call
          if @href
            helpers.link_to(@label, @href, class: css_classes, aria: {label: @aria_label})
          else
            helpers.button_tag(@label, type: @type, class: css_classes, disabled: @disabled, aria: {label: @aria_label})
          end
        end

        private

        def normalize_variant(variant)
          value = variant.to_sym
          return value if VARIANTS.include?(value)

          :primary
        end

        def normalize_size(size)
          value = size.to_sym
          return value if SIZES.include?(value)

          :md
        end

        def css_classes
          helpers.class_names(
            "ds-button",
            "ds-button--#{@variant}",
            "ds-button--#{@size}",
            {"is-disabled": @disabled},
            @classes
          )
        end
      end
    end
  end
end
