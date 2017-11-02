#!/bin/sh
function gl () {
    now_pwd=`pwd`
    while [[ ! -d ".git" ]]
    do
        cd ..
        if [[ `pwd` = '/' ]]
        then
            echo 'Here is Root, Damn! Let us go back, biu~~'
            cd ${now_pwd}
            return
        fi
    done
    head=`cat .git/HEAD`
    current_head=${head##*/}
    user=${current_head%%_*}
    if [[ $current_head = *_* ]]
    then
        branch=${current_head%%+*}
        branch=${branch##*_}
        user_branch="${user}_${branch}"
        git fetch origin
        git merge $user_branch origin/$user_branch
        git merge $user_branch origin/$branch
        if [[ $current_head = *+* ]]
        then
            git merge $current_head origin/${user_branch}
            git merge $current_head origin/$current_head
            git merge $current_head $user_branch
        fi
    else
        echo "you are not in your own branch"
    fi
}

function gh () {
    now_pwd=`pwd`
    while [[ ! -d ".git" ]]
    do
        cd ..
        if [[ `pwd` = '/' ]]
        then
            echo 'Here is Root, Damn! Let us go back, biu~~'
            cd ${now_pwd}
            return
        fi
    done
    head=`cat .git/HEAD`
    current_head=${head##*/}
    user=${current_head%%_*}
    if [[ $current_head = *_* ]]
    then
        branch=${current_head%%+*}
        branch=${branch##*_}
        user_branch="${user}_${branch}"
        git fetch origin
        git merge $user_branch origin/$user_branch
        git merge $user_branch origin/$branch
        if [[ $current_head = *+* ]]
        then
            git push origin $user_branch
            git fetch origin
            git checkout $current_head
            git merge origin/${user_branch}
            git merge $current_head origin/$current_head
            git push origin $current_head
        else
            git push origin $user_branch
        fi
    else
        echo "you are not in your own branch"
    fi
}

function gr () {
    now_pwd=`pwd`
    while [[ ! -d ".git" ]]
    do
        cd ..
        if [[ `pwd` = '/' ]]
        then
            echo 'Here is Root, Damn! Let us go back, biu~~'
            cd ${now_pwd}
            return
        fi
    done
    head=`cat .git/HEAD`
    current_head=${head##*/}
    origin=`git ls-remote --get-url origin`
    user=${current_head%%_*}
    if [[ $current_head = *_* ]]
    then
        branch=${current_head%%+*}
        branch=${branch##*_}
        if [[ $current_head = *+* ]]
        then
            user_branch="$current_head"
        else
            user_branch="${user}_${branch}"
        fi
        msg="${user_branch} pull-request"
        desc=`git log origin/$branch..$user_branch --pretty=oneline --abbrev-commit --no-merges`
        result=$(echo $origin | grep "github.com")
        if [[ "$result" != "" ]]
        then
            hub pull-request -o -m $msg -b $branch -h $user_branch
        else
            projectId=`git config --get gitlab.projectId`
            assignee=`git config --get gitlab.assignee`
            gitlab addMergeRequest $projectId $user_branch $branch $assignee $msg
        fi
    else
        echo "you are not in your own branch"
    fi
}

function gnb () {
    default_branch=''
    if [ -z "$1" ]; then
        echo "Usage: gnb branchName"
        return
    else
        echo
    if [[ $1 == *_* ]]; then
        echo "Usage: defaultBranch name should not include _"
        return
      else
        default_branch=$1
      fi
    fi

   now_pwd=`pwd`
   while [[ ! -d ".git" ]]; do
    cd ..
    if [[ `pwd` = '/' ]]; then
        echo 'Here is Root, Damn! Let us go back, biu~~'
        cd ${now_pwd}
        return
    fi
    done

    head=`cat .git/HEAD`
    user=`git config --get user.name`
    user_branch="${user}_$default_branch"

    git fetch origin
    git fetch --tags

    if [ -f ".git/refs/remotes/origin/$default_branch" ]; then
        echo "Remote has ${default_branch}"
        # 远程有服务器分支
        git checkout $default_branch
        git branch --set-upstream-to=origin/$default_branch
        git merge origin/${default_branch}
        git push origin ${default_branch}
    else
        echo "Remote don't have ${default_branch}"
        # 服务器没有这个分支
        git checkout -b $default_branch
        git push origin ${default_branch}
        git branch --set-upstream-to=origin/$default_branch
    fi


    if [ -f ".git/refs/remotes/origin/$user_branch" ]; then
        echo "Remote has ${user_branch}"
        # 远程有服务器分支
        git checkout $user_branch
        git branch --set-upstream-to=origin/$user_branch
        git merge origin/${user_branch}
        git push origin ${user_branch}
    else
        echo "Remote don't have ${user_branch}"
        # 服务器没有这个分支
        git checkout -b $user_branch
        git push origin ${user_branch}
        git branch --set-upstream-to=origin/$user_branch
    fi
    gl
}

function gcd () {
    now_pwd=`pwd`
    while [[ ! -d ".git" ]]
    do
        cd ..
        if [[ `pwd` = '/' ]]
        then
            echo 'Here is Root, Damn! Let us go back, biu~~'
            cd ${now_pwd}
            return
        fi
    done
    head=`cat .git/HEAD`
    user=`git config --get user.name`
    if [[ $head = *_* ]]
    then
        echo "you have already switched to your own branch"
    else
        branch=${head##*/}
        if [[ -z "$1" ]]
        then
            user_branch="${user}_${branch}"
        else
            user_branch="${user}_${branch}+$1"
        fi
        git checkout $user_branch
    fi
}

function gdc() {
    now_pwd=`pwd`
    while [[ ! -d ".git" ]];do
        cd ..
        if [[ `pwd` == '/' ]]; then
            echo 'Here is Root, Damn! Let us go back, biu~~'
            cd ${now_pwd}
            return
        fi
    done;
    head=`cat .git/HEAD`

    current_head=${head##*/}

    user=${current_head%%_*}

    if [[ $current_head == *_* ]]; then
        if [[ $current_head == *+* ]]; then
            branch=${current_head%%+*}
        elif [[ $current_head == *-* ]]; then
            branch=${current_head##*_}
        else
            branch=${current_head##*_}
        fi
        git checkout $branch
    else
        default_branch=''
        if [ -z "$1" ]; then
          default_branch=`git remote show origin | grep "HEAD branch" | cut -d : -f2 | cut -c 2-`
        else
          default_branch=$1
        fi
        git checkout $default_branch
    fi
}

