module Api
  module V1
    class OmigaInscriptionsController < ApplicationController
      before_action :validate_query_params, only: :show
      before_action :validate_pagination_params, :pagination_params,
                    only: :index

      def index
        udts = Udt.omiga_inscription

        if stale?(udts)
          udts = sort_udts(udts).page(@page).per(@page_size).fast_page
          options = FastJsonapi::PaginationMetaGenerator.new(
            request:,
            records: udts,
            page: @page,
            page_size: @page_size,
          ).call

          render json: UdtSerializer.new(udts, options)
        end
      end

      def show
        udt = Udt.find_by!(type_hash: params[:id])
        render json: UdtSerializer.new(udt)
      rescue ActiveRecord::RecordNotFound
        raise Api::V1::Exceptions::UdtNotFoundError
      end

      private

      def validate_query_params
        validator = Validations::Udt.new(params)

        if validator.invalid?
          errors = validator.error_object[:errors]
          status = validator.error_object[:status]

          render json: errors, status:
        end
      end

      def pagination_params
        @page = params[:page] || 1
        @page_size = params[:page_size] || Udt.default_per_page
      end

      def sort_udts(records)
        sort, order = params.fetch(:sort, "id.desc").split(".", 2)
        sort =
          case sort
          when "created_time" then "block_timestamp"
          when "transactions" then "h24_ckb_transactions_count"
          when "addresses_count" then "addresses_count"
          else "id"
          end

        if order.nil? || !order.match?(/^(asc|desc)$/i)
          order = "asc"
        end

        records.order("#{sort} #{order}")
      end
    end
  end
end
