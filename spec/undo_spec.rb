require File.expand_path('../spec_helper', __FILE__)

module Mongoid
  module Undo
    describe self do
      class Document
        include Mongoid::Document
        include Mongoid::Undo
        
        field :name, type: String
      end


      subject { Document.new(name: 'foo') }
      let(:name) { subject.name }
      let(:action) { subject.send(:_action) }


      describe 'creating' do
        before { subject.save }


        it 'sets action to :create' do
          action.must_equal :create
        end


        describe 'undoing' do
          before { subject.undo }


          it 'deletes' do
            subject.persisted?.wont_equal true
          end


          it 'keeps :create action' do
            action.must_equal :create
          end


          describe 'redoing' do
            before { subject.redo }


            it 'restores' do
              subject.persisted?.must_equal true
            end


            it 'keeps :create action' do
              action.must_equal :create
            end
          end
        end


        describe 'updating' do
          before { subject.update_attributes(name: 'bar') }


          it 'sets action to :update' do
            action.must_equal :update
          end


          describe 'undoing' do
            before { subject.undo }


            it 'retrieves' do
              name.must_equal 'foo'
            end


            it 'saves a new version' do
              subject.version.must_equal 3
            end


            it 'keeps :update action' do
              action.must_equal :update
            end


            describe 'redoing' do
              before { subject.redo }


              it 'retrieves' do
                name.must_equal 'bar'
              end


              it 'saves a new version' do
                subject.version.must_equal 4
              end


              it 'keeps :update action' do
                action.must_equal :update
              end
            end
          end
        end


        describe 'destroying' do
          before { subject.destroy }


          it 'sets action to :destroy' do
            action.must_equal :destroy
          end


          it 'marks as destroyed' do
            subject.persisted?.must_equal false
          end


          describe 'undoing' do
            before { subject.undo }


            it 'restores' do
              subject.persisted?.wont_equal false
            end


            it 'keeps :destroy action' do
              action.must_equal :destroy
            end


            describe 'redoing' do
              before { subject.redo }


              it 'deletes' do
                subject.persisted?.must_equal false
              end


              it 'keeps :destroy action' do
                action.must_equal :destroy
              end
            end
          end
        end
      end


      describe :redo do
        it 'is a convenient alias for undo' do
          subject.method(:redo).must_equal subject.method(:undo)
        end
      end


      describe :_action do
        it 'is a symbol' do
          subject.fields['_action'].options[:type].must_equal Symbol
        end


        it 'is versionless' do
          subject.fields['_action'].options[:versioned].must_equal false
        end
      end


      describe 'localization' do
        class Localized
          include Mongoid::Document
          include Mongoid::Undo
          
          field :language, localize: true
        end


        it 'works too with localized fields' do
          subject = Localized.create(language: 'English')
          
          subject.update_attributes(language: 'English Updated')
          subject.undo
          subject.language.must_equal 'English'
          
          subject.redo
          subject.language.must_equal 'English Updated'
        end
      end
    end
  end
end
