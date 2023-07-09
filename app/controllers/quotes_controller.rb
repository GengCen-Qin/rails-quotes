class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def index
    @quotes = current_company.quotes.ordered
  end

  def show
    @line_item_dates = @quote.line_item_dates.includes(:line_items).ordered
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = current_company.quotes.build(quote_params)

    if @quote.save
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: "Quote was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully created" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: "Quote was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_path, notice: "Quote was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Quote was successfully destroyed." }
    end
  end

  private

  def set_quote
    @quote = current_company.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:name)
  end

  def handle_not_found
    redirect_to quotes_path, notice: "未找到指定数据."
  end
end
