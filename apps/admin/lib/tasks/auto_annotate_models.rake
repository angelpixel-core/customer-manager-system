if defined?(Annotate)
  File.singleton_class.alias_method(:exists?, :exist?) unless File.respond_to?(:exists?)
  Object.const_set(:Fixnum, Integer) unless Object.const_defined?(:Fixnum)
  Object.const_set(:Bignum, Integer) unless Object.const_defined?(:Bignum)

  task :set_annotation_options do
    Annotate.set_defaults(
      "position_in_class" => "before",
      "position_in_factory" => "before",
      "position_in_fixture" => "before",
      "position_in_test" => "before",
      "show_indexes" => "true",
      "simple_indexes" => "false",
      "model_dir" => "app/models",
      "exclude_tests" => "true",
      "exclude_fixtures" => "true",
      "exclude_factories" => "true",
      "exclude_serializers" => "true",
      "exclude_sti_subclasses" => "false"
    )
  end

  Annotate.load_tasks
end
