require 'rails_helper'

describe Api::SrpmsController do
  describe '#show' do
    before { get :show, params: { id: 'glibc', format: :json } }

    it { should render_template(:show) }

    it { should respond_with(:ok) }
  end

  # private methods

  describe '#resource' do
    let(:params) { { id: 'glibc' } }

    before { expect(subject).to receive(:params).and_return(params) }

    before do
      #
      # subject.branch.srpms.find_by!(name: params[:id])
      #
      expect(subject).to receive(:branch) do
        double.tap do |a|
          expect(a).to receive(:srpms) do
            double.tap do |b|
              expect(b).to receive(:find_by!).with(name: params[:id])
            end
          end
        end
      end
    end

    specify { expect { subject.send(:resource) }.not_to raise_error }
  end
end
