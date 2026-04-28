module DesignSystem
  module UI
    module Primitives
      # Primitive select component with optional label.
      class SelectComponent < DesignSystem::UI::Component
        def initialize(name:, options:, value: nil, label: nil, include_blank: nil, classes: nil)
          @name = name
          @options = options
          @value = value
          @label = label
          @include_blank = include_blank
          @classes = classes
        end

        def call
          helpers.content_tag(:div, class: "ds-select") do
            helpers.concat helpers.label_tag(@name, @label, class: "ds-select__label") if @label
            helpers.concat helpers.select_tag(@name, select_options_html, class: css_classes)
          end
        end

        private

        def select_options_html
          helpers.options_for_select(options_for_select, @value)
        end

        def options_for_select
          base = @options.map { |option| [option.fetch(:label), option.fetch(:value)] }
          return base if @include_blank.nil?

          [[@include_blank, ""]] + base
        end

        def css_classes
          helpers.class_names("ds-select__control", @classes)
        end
      end
    end
  end
end
