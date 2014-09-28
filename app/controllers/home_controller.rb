class HomeController < ApplicationController
  def home
       @contact = Contact.new
  end

  def help
  end
end
