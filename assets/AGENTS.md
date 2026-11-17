# AGENTS.md

本项目采用“人在回路”的协作方式。开始任何工作之前，先使用 `human-in-the-loop-dev` 技能，
并在整个会话中遵循其中的工作循环、硬性规则和 Git 约定。

- 协作规则见技能的 `SKILL.md`。
- 文档规范见技能内的 `references/docs-spec.md`。
- 项目文档在 `docs/` 中：模块地图 `docs/architecture.md`、路线图 `docs/roadmap.md`、决策记录 `docs/decisions/`。

该技能以 git 子模块的形式引入。技能不可用时，先执行 `git submodule update --init`，
再按技能内 `README.md` 的说明为所用的 AI 工具创建链接。

## 本项目的补充约定

无。
