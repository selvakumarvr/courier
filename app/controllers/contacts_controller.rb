class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
 before_action  :authenticate, except: [:create]
  protect_from_forgery with: :null_session
  skip_before_filter  :verify_authenticity_token


  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # POST /contacts
  # POST /contacts.json
  def create

Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "heroku.com",
                           :user_name => "selvakumarvr",
                           :password  => "vr14021980",
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

    contact1 = Contact.new(contact_params)
  @contact = Contact.new


Mail.deliver do
  to 'selvakumarvr@gmail.com'
  from contact1.email
  subject ' Project request from '+ contact1.email
  body contact1.message
end

    respond_to do |format|
      if @contact.save
        format.html { redirect_to root_path,  notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params

      params.require(:contact).permit(:name, :email, :phone, :message)

    end
    
     def authenticate
          authenticate_or_request_with_http_basic do |name, password|
           name = "admin"  && password == "admin"
          end  
    end
end
