namespace :yard do
  namespace :maintenance do
    def run_step!(label, command, chdir: Rails.root)
      puts "\n== #{label} =="
      success = Bundler.with_unbundled_env do
        system(command, chdir: chdir)
      end
      raise "#{label} failed" unless success
    end

    desc "Run weekly YARD maintenance review across monorepo packages"
    task :weekly_review do
      report_dir = Rails.root.join("tmp", "yard-maintenance")
      FileUtils.mkdir_p(report_dir)

      run_step!(
        "customer_core YARD stats",
        "bundle exec yard stats --list-undoc > #{report_dir.join('customer_core.txt')}",
        chdir: Rails.root.join("..", "..", "packages", "customer_core")
      )

      run_step!(
        "design_system YARD stats",
        "bundle exec yard stats --list-undoc > #{report_dir.join('design_system.txt')}",
        chdir: Rails.root.join("..", "..", "packages", "design_system")
      )

      run_step!(
        "admin YARD stats",
        "bundle exec yard stats --list-undoc > #{report_dir.join('admin.txt')}",
        chdir: Rails.root
      )

      puts "\nYARD maintenance reports written to: #{report_dir}"
    end
  end
end
