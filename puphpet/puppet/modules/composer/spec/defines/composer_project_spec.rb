require 'spec_helper'

describe 'composer::project' do
  ['RedHat', 'Debian'].each do |osfamily|
    context "on #{osfamily} operating system family" do
      let(:facts) { {
            :osfamily => osfamily,
        } }

      context 'with default params' do
        let(:title) { 'myproject' }
        let(:params) { {
          :project_name => 'projectzzz',
          :target_dir   => '/my/subpar/project',
        } }

        it { should contain_class('git') }
        it { should contain_class('stdlib') }
        it { should contain_class('composer') }

        it {
          should contain_exec('composer_create_project_myproject').without_user.with({
            :command => "php /usr/local/bin/composer --stability=dev --no-interaction create-project projectzzz /my/subpar/project || rm -rf /my/subpar/project",
            :tries   => 3,
            :timeout => 1200,
            :creates => '/my/subpar/project',
          })
        }
      end

      context 'with all custom params' do
        let(:title) { 'whoadawg' }
        let(:params) { {
          :project_name   => 'whoadawg99',
          :target_dir     => '/my/mediocre/project',
          :version        => '0.0.8',
          :dev            => true,
          :prefer_source  => true,
          :stability      => 'dev',
          :repository_url => 'git@github.com:trollface/whoadawg.git',
          :keep_vcs       => true,
          :tries          => 2,
          :timeout        => 600,
          :user           => 'mrploch',
          :working_dir    => '/my/working-dir',
        } }

        it { should contain_class('git') }
        it { should contain_class('stdlib') }
        it { should contain_class('composer') }

        it {
          should contain_exec('composer_create_project_whoadawg').with({
            :command => %r{php /usr/local/bin/composer --stability=dev --repository-url=git@github.com:trollface/whoadawg.git --prefer-source --keep-vcs --working-dir=/my/working-dir --no-interaction create-project whoadawg99 /my/mediocre/project 0.0.8 || rm -rf /my/subpar/project},
            :tries   => 2,
            :timeout => 600,
            :creates => '/my/mediocre/project',
            :user    => 'mrploch',
            :cwd     => '/my/working-dir',
          })
        }
      end
    end
  end
end
