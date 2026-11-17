# human-in-the-loop-dev

一个“人在回路”的 AI 协作开发技能（Agent Skill）。

AI 能在很短时间内产出大量代码，用户来不及审阅，慢慢就不再了解自己的项目，只能把它全权交给 AI 维护。
这个技能让 AI 换一种方式工作：先讨论并给出选项，由用户做决定，再一次只实现一个小步骤，
同时维护一份简短的模块地图、路线图和决策记录。代价是速度变慢，换来的是用户始终看得懂自己的项目。

## 内容

| 路径 | 内容 |
|---|---|
| `SKILL.md` | 工作循环、硬性规则、参与度调节、Git 约定 |
| `references/docs-spec.md` | 文档规范：模块地图、路线图、现行决策、决策记录的格式和更新时机 |
| `assets/AGENTS.md` | 放进项目根目录的入口文件模板 |
| `assets/docs/` | 项目 `docs/` 目录的初始模板 |
| `scripts/link.ps1`、`scripts/link.sh` | 为读取其他目录的 AI 工具创建指向本技能的链接 |

## 安装

以 git 子模块的形式放进项目的 `.agents/skills/`：

```bash
git submodule add https://github.com/ISQIShI/human-in-the-loop-dev.git .agents/skills/human-in-the-loop-dev
```

Claude Code 只从 `.claude/skills/` 读取项目技能。运行下面的脚本，在那里创建一个指向本技能的链接，
技能在磁盘上仍然只有一份，修改后不需要同步。

Windows（目录联接，不需要管理员权限或开发者模式）：

```powershell
pwsh -ExecutionPolicy Bypass -File .agents/skills/human-in-the-loop-dev/scripts/link.ps1
```

macOS、Linux（符号链接）：

```bash
sh .agents/skills/human-in-the-loop-dev/scripts/link.sh
```

链接是本机的，不进入版本控制，所以要在项目的 `.gitignore` 中忽略 `.claude/`。
每次新克隆项目或移动项目目录后，重新运行一次脚本。
要链接到其他目录时，把目录作为参数传给脚本（`link.ps1` 用 `-Target`）。

最后把 `assets/AGENTS.md` 复制到项目根目录，把 `assets/docs/` 复制为项目的 `docs/`。

## 克隆已使用本技能的项目

```bash
git clone --recurse-submodules <项目地址>
```

然后运行一次上面的链接脚本。

## 更新

在项目中拉取技能的最新版本，并提交子模块指向的变化：

```bash
git submodule update --remote .agents/skills/human-in-the-loop-dev
```

## 许可证

[MIT](LICENSE)
