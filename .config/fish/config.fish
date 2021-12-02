if status is-interactive
    # Commands to run in interactive sessions can go here
end

function prompt_pwd --description 'Print the current working directory, shortened to fit the prompt'
    set -l options h/help d/dir-length= D/full-length-dirs=
    argparse -n prompt_pwd $options -- $argv
    or return

    if set -q _flag_help
        __fish_print_help prompt_pwd
        return 0
    end

    set -q argv[1]
    or set argv $PWD

    set -ql _flag_d
    and set -l fish_prompt_pwd_dir_length $_flag_d

    set -q fish_prompt_pwd_dir_length
    or set -l fish_prompt_pwd_dir_length 1

    set -l fulldirs 0
    set -ql _flag_D
    and set fish_prompt_pwd_full_dirs $_flag_D

    set -q fish_prompt_pwd_full_dirs
    or set -l fish_prompt_pwd_full_dirs 1

    for path in $argv
        # Replace $HOME with "~"
        set -l realhome ~
        set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $path)

        if test "$fish_prompt_pwd_dir_length" -eq 0
            echo $tmp
        else
            # Shorten to at most $fish_prompt_pwd_dir_length characters per directory
            # with full-length-dirs components left at full length.
            set -l full
            if test $fish_prompt_pwd_full_dirs -gt 0
                set -l all (string split -m (math $fish_prompt_pwd_full_dirs - 1) -r / $tmp)
                set tmp $all[1]
                set full $all[2..]
            else if test $fish_prompt_pwd_full_dirs -eq 0
                # 0 means not even the last component is kept
                string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*' '$1' $tmp
                continue
            end

            string join / (string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' $tmp) $full
        end
    end
end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status --background=red white

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '$'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    echo -n -s [(prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status ]$suffix " "
end

function fish_greeting
	set_color $fish_color_operator 
	date 
	# echo
	# figlet Poggies!!! | lolcat
	# echo
end
