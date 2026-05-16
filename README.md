# 产品开发工作流

> AI 驱动的 Claude Code 产品开发工作流 — 从选题到交付的结构化阶段门控流程。

[English](./README_EN.md)

## 概述

9 阶段产品开发工作流：

- **编排器（Orchestrator）** 管理阶段流转、状态追踪和审批门控
- **阶段技能（Phase Skills）** 定义每个阶段的领域知识和执行指南
- **执行代理（Agents）** 每阶段动态生成，读取技能并产出交付物
- **人类决策** 每个阶段完成后暂停，等待人工审批

适用场景：软件产品（Web 应用、SaaS、移动应用）。

## 阶段流程

```
1. 选题评估       → 验证产品创意的可行性和市场信号
2. 市场研究       → 竞品分析、用户画像、市场规模估算
3. 产品设计       → 功能规划、用户故事、信息架构、用户流程
4. 需求文档 (PRD) → 详细需求、验收标准、MVP 范围界定
5. 系统设计       → 技术栈、API 契约、数据库设计（与阶段 6 并行）
6. UI/UX 设计     → 设计令牌、页面布局、交互原型（与阶段 5 并行）
7. 前端 + 后端开发 → 并行开发
8. QA 测试        → 测试用例、测试执行、缺陷报告
9. 交付部署       → 部署清单、环境配置、上线验证
```

## 安装

### 方式 1：全局安装（推荐，所有项目可用）

```bash
bash <(curl -sL https://raw.githubusercontent.com/ShadowsHunter/product-dev-workflow/main/install.sh) --global
```

### 方式 2：安装到指定项目

```bash
bash <(curl -sL https://raw.githubusercontent.com/ShadowsHunter/product-dev-workflow/main/install.sh)
```

在项目根目录执行，仅当前项目可用。

### 方式 3：克隆后安装

```bash
git clone https://github.com/ShadowsHunter/product-dev-workflow.git
cd product-dev-workflow
./install.sh --global                    # 全局安装
./install.sh /path/to/your/project       # 安装到指定项目
```

## 使用方法

```bash
# 启动新的产品工作流
/workflow start 做一个面向自由职业者的记账App

# 查看当前进度
/workflow status

# 批准当前阶段，进入下一阶段
/workflow approve

# 驳回并要求修改
/workflow reject 竞品定价分析不够详细

# 从指定阶段重新开始
/workflow redo market-research

# 跳过某个阶段
/workflow skip ui-ux-design
```

## 架构

安装后的项目结构：

```
项目根目录
├── .claude/
│   ├── commands/
│   │   └── workflow.md          # /workflow 命令入口
│   └── skills/
│       ├── workflow/             # 编排器技能
│       ├── topic-selection/      # 阶段 1：选题评估
│       ├── market-research/      # 阶段 2：市场研究
│       ├── product-design/       # 阶段 3：产品设计
│       ├── prd-writing/          # 阶段 4：需求文档
│       ├── system-design/        # 阶段 5：系统设计（并行）
│       ├── ui-ux-design/        # 阶段 6：UI/UX 设计（并行）
│       ├── frontend-dev/         # 阶段 7a：前端开发（并行）
│       ├── backend-dev/          # 阶段 7b：后端开发（并行）
│       ├── qa-testing/           # 阶段 8：QA 测试
│       └── delivery/             # 阶段 9：交付部署
└── docs/workflow/                # 输出文档（运行时生成）
    ├── workflow-state.json       # 工作流状态
    ├── 01-topic-selection.md     # 选题报告
    ├── 02-market-research.md     # 市场研究报告
    ├── 03-product-design.md      # 产品设计文档
    ├── 04-prd.md                 # PRD 文档
    ├── 05-system-design.md       # 系统设计文档
    ├── 06-ui-ux-design.md        # UI/UX 设计规范
    ├── 07-test-cases.md          # 测试用例
    ├── 08-test-report.md         # 测试报告
    └── 09-delivery-checklist.md  # 交付清单
```

## 工作原理

1. `/workflow start` 初始化状态文件，生成第一个阶段的执行代理
2. 每个代理读取对应的技能文件和前置阶段文档，执行并产出交付物
3. 阶段完成后，编排器暂停并展示审批门控
4. 人类执行 `/workflow approve` 继续或 `/workflow reject` 打回重做
5. 系统设计和 UI/UX 设计并行执行（阶段 5 + 6）
6. 前端开发和后端开发并行执行（阶段 7）
7. 所有状态保存在 `workflow-state.json`，支持 `/clear` 和跨会话恢复

## 环境要求

- Claude Code CLI 或 Claude Code 桌面版
- 无额外依赖

## 许可证

MIT
