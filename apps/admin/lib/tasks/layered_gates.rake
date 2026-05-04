namespace :quality do
  namespace :gates do
    def run_step!(label, command, chdir: Rails.root)
      puts "\n== #{label} =="
      success = Bundler.with_unbundled_env do
        system(command, chdir: chdir)
      end
      raise "#{label} failed" unless success
    end

    desc "Run core unit/use-case specs"
    task :core do
      run_step!(
        "Core specs",
        "bundle exec rspec",
        chdir: Rails.root.join("..", "..", "packages", "customer_core")
      )
    end

    desc "Run admin adapter integration specs"
    task :adapters do
      run_step!(
        "Admin adapters",
        "bundle exec rspec spec/requests/customer/create_spec.rb",
        chdir: Rails.root
      )
    end

    desc "Run platform event routing/retry/DLQ specs"
    task :platform_events do
      run_step!(
        "Platform events",
        "bundle exec rspec spec/platform/events",
        chdir: Rails.root
      )
    end

    desc "Run integration serializers and forwarder specs"
    task :integrations do
      run_step!(
        "Integration forwarders",
        "bundle exec rspec spec/platform/integrations",
        chdir: Rails.root
      )
    end

    desc "Run E2E request gate (CustomerCreated -> publisher -> worker -> forwarder)"
    task :e2e do
      run_step!(
        "E2E gate",
        "bundle exec rspec spec/requests/customer/create_spec.rb --example 'runs end-to-end publish flow to worker and integration forwarder'",
        chdir: Rails.root
      )
    end

    desc "Run Bullet diagnostics for customer create/list flow (warn-only)"
    task :bullet_warn do
      run_step!(
        "Bullet warn-only",
        "BULLET_DIAGNOSTIC=1 bundle exec rspec spec/requests/customer/create_spec.rb spec/system/admin_customer_form_spec.rb",
        chdir: Rails.root
      )
    end

    desc "Run Bullet diagnostics for customer create/list flow (blocking)"
    task :bullet_enforced do
      run_step!(
        "Bullet enforced",
        "BULLET_DIAGNOSTIC=1 BULLET_STRICT=1 bundle exec rspec spec/requests/customer/create_spec.rb spec/system/admin_customer_form_spec.rb",
        chdir: Rails.root
      )
    end

    desc "Run all layered testing gates"
    task all: [:core, :adapters, :platform_events, :integrations, :e2e, :bullet_enforced]
  end

  desc "Run layered testing gates"
  task gates: "quality:gates:all"
end
