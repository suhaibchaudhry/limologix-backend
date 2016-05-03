class Base < Grape::API
  mount V1::Root
end