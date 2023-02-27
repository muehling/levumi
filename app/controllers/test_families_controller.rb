class TestFamiliesController < ApplicationController
  def destroy_safe
    test_family = TestFamily.find(params[:id])
    if !test_family.nil? && !test_family.tests.exists?
      test_family.destroy
      head :ok
    else
      head 403
    end
  end

  def update
    test_family = TestFamily.find(params[:id])
    if !test_family.nil? && test_family.update(name: params[:name])
      head :ok
    else
      head 304
    end
  end
end
