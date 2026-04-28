module Admin
  module CustomersRoutes
    def self.extended(router)
      router.instance_exec do
        namespace :admin do
          namespace :customers do
            get :health, to: "/admin/customers_extensions#health", as: :health
          end
        end
      end
    end
  end
end
