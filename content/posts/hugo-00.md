---
title: "使用Hugo在github上搭建博客"
date: 2021-04-25T11:29:00+08:00
draft: false
author: ["Jin"]
---

> Hugo is one of the most popular open-source static site generators. With its amazing speed and flexibility, Hugo makes building websites fun again.
`Hugo`是一个静态网页框架，可以快速生成网页，并且拥有许多的主题

### 安装`Hugo`

在`archlinux`中

```bash
sudo pacman -S hugo
```

使用源码安装

需要有`git`和`go(>=1.11)`

```bash
mkdir $HOME/src
cd $HOME/src
git clone https://github.com/gohugoio/hugo.git
cd hugo
go install --tags extended
```

```
% hugo version  
hugo v0.82.0+extended linux/amd64 BuildDate=unknown
```

### 创建网站

先在`github`上新建一个项目

然后新建一个`hugo`网站项目

```
hugo new site blog -f yml
```

初始化`git`，并设置默认分支名为`main`

```
git init
git branch -m main
```

设置主题，这里设置`PaperMod`主题

```
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod --depth=1
git submodule update --init --recursive
```

然后生成静态网页

```
hugo -d docs
```

上传到`github`

```
git add *
git commit -m "first commit"
git remote add origin git@github.com:MurphyWZhu/blog.git
git push -u origin main
```

设置`github`

![github_page](https://mublog.oss-cn-beijing.aliyuncs.com/hugo-00_github_page.png)

配置网站

下面是一些我的配置，可以根据需要修改

```yaml
baseURL: https://murphywzhu.github.io/blog/
languageCode: zh-cn
defaultContentLanguage: zh-cn
title: 锦酱的博客
theme: "PaperMod"
languages:
    zh-cn:
        languageName: "简体中文"
        weight: 1
        menu:
            main:
                - name: Search
                  url: search/
                  weight: 10
                - name: Tags
                  url: tags/
                  weight: 10
params:
    profileMode:
        enabled: true
        title: "锦酱" # optional default will be site title
        subtitle: "锦酱!又出Bug啦!"
        imageUrl: "https://mublog.oss-cn-beijing.aliyuncs.com/mutx.jpeg" # optional
        imageTitle: "图片被吃掉了哎!" # optional
        imageWidth: 120 # custom size
        imageHeight: 120 # custom size
        buttons:
            - name: 文章
              url: "posts/"
            - name: Github
              url: "https://github.com/murphywzhu"
outputs:
    home:
        - HTML
        - RSS
        - JSON # is necessary
```

然后生成并`push`到`github`上

```
hugo -d docs
git add *
git commit -m "updates $(date)"
git push -u origin main
```

也可以将这些步骤写成脚本

```bash
#! /bin/bash
hugo -d docs
git add *
git commit -m "updates $(date)"
git push -u origin main
```

接下来就应该可以访问了
