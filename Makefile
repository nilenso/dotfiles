bak_timestamp = $(shell date +%s)
bak_dir = $(HOME)/.dotfiles.bak/$(bak_timestamp)

# TODO: Separate backup and link
backup_and_link = \
	if [ -f $(HOME)/$(2) -o -d $(HOME)/$(2) -o -L $(HOME)/$(2) ] ; then \
		cp -RLH $(HOME)/$(2) $(bak_dir)/$(2); \
		rm -rf $(HOME)/$(2); \
	fi; \
	ln -s `pwd`/$(1) $(HOME)/$(2);

install: configure

configure: configure-ack configure-bash configure-zsh configure-gem configure-git configure-irb configure-pry configure-tmux configure-vim configure-dotemacs

create-backup: 
	mkdir -p $(bak_dir)

configure-ack: create-backup
	$(call backup_and_link,ack/ackrc,.ackrc)

configure-bash: create-backup
	$(call backup_and_link,bash/bashrc,.bashrc)

configure-gem: create-backup
	$(call backup_and_link,gem/gemrc,.gemrc)

configure-git: create-backup
	$(call backup_and_link,git/gitignore,.gitignore)
	$(call backup_and_link,git/gitconfig.withoutuser,.gitconfig.withoutuser)

configure-irb: create-backup
	$(call backup_and_link,irb/irbrc,.irbrc)

configure-pry: create-backup
	$(call backup_and_link,pry/pryrc,.pryrc)

# We don't backup_and_link rbenv if it's already there. Backing this up would move all your ruby shims.
# TODO: we should still link rbenv to `dotfiles` if there's no rbenv to be found, so that we can run `make configure-rbenv` to upgrade.
# For that to work, backup_and_link needs to be split into 2, so that we can only call link.
configure-rbenv: update-submodules create-backup
	if [ ! -d $(HOME)/.rbenv ]; then \
		cp -r `pwd`/rbenv/rbenv $(HOME)/.rbenv; \
	fi;
	echo 'export PATH="$(HOME)/.rbenv/bin:$(PATH)"' >> ~/.bashrc
	echo 'export PATH="$(HOME)/.rbenv/bin:$(PATH)"' >> ~/.zshrc
	echo 'eval "$$(rbenv init -)"' >> ~/.bashrc
	echo 'eval "$$(rbenv init -)"' >> ~/.zshrc

configure-tmux: create-backup
	$(call backup_and_link,tmux/tmux.conf,.tmux.conf)

configure-vim: create-backup
	$(call backup_and_link,vim/vimrc,.vimrc)

# We don't symlink the oh-my-zsh submodule as oh-my-zsh auto-updates itself.
configure-zsh: create-backup
	if [ ! -d $(HOME)/.oh-my-zsh ]; then \
		cp -r `pwd`/zsh/oh-my-zsh $(HOME)/.oh-my-zsh; \
	fi;
	$(call backup_and_link,zsh/zshrc,.zshrc)

configure-dotemacs: update-submodules
	$(MAKE) -C dotemacs

update-submodules:
	git submodule init
	git submodule update
