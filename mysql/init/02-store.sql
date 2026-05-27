-- ----------------------------
-- 店掌柜业务模块数据库表
-- ----------------------------

-- 商品分类表
CREATE TABLE IF NOT EXISTS store_category (
  category_id     bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  parent_id       bigint(20)      DEFAULT 0               COMMENT '父分类ID',
  category_name   varchar(50)     NOT NULL                COMMENT '分类名称',
  order_num       int(4)          DEFAULT 0               COMMENT '显示顺序',
  status          char(1)         DEFAULT '0'             COMMENT '状态（0正常 1停用）',
  create_by       varchar(64)     DEFAULT ''              COMMENT '创建者',
  create_time     datetime                                COMMENT '创建时间',
  update_by       varchar(64)     DEFAULT ''              COMMENT '更新者',
  update_time     datetime                                COMMENT '更新时间',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- 商品表
CREATE TABLE IF NOT EXISTS store_product (
  product_id      bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  product_code    varchar(50)     NOT NULL                COMMENT '商品编码',
  product_name    varchar(100)    NOT NULL                COMMENT '商品名称',
  category_id     bigint(20)      DEFAULT NULL            COMMENT '分类ID',
  specification   varchar(50)     DEFAULT NULL            COMMENT '规格',
  unit            varchar(20)     DEFAULT NULL            COMMENT '单位',
  cost_price      decimal(10,2)   DEFAULT 0.00            COMMENT '成本价',
  sale_price      decimal(10,2)   DEFAULT 0.00            COMMENT '售价',
  stock_quantity  int(11)         DEFAULT 0               COMMENT '库存数量',
  safety_stock    int(11)         DEFAULT 0               COMMENT '安全库存',
  product_image   varchar(200)    DEFAULT NULL            COMMENT '商品图片',
  barcode         varchar(50)     DEFAULT NULL            COMMENT '条码',
  status          char(1)         DEFAULT '0'             COMMENT '状态（0上架 1下架）',
  del_flag        char(1)         DEFAULT '0'             COMMENT '删除标志（0存在 2删除）',
  create_by       varchar(64)     DEFAULT ''              COMMENT '创建者',
  create_time     datetime                                COMMENT '创建时间',
  update_by       varchar(64)     DEFAULT ''              COMMENT '更新者',
  update_time     datetime                                COMMENT '更新时间',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (product_id),
  UNIQUE KEY uk_product_code (product_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 供应商表
CREATE TABLE IF NOT EXISTS store_supplier (
  supplier_id     bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  supplier_name   varchar(100)    NOT NULL                COMMENT '供应商名称',
  contact_person  varchar(50)     DEFAULT NULL            COMMENT '联系人',
  contact_phone   varchar(20)     DEFAULT NULL            COMMENT '联系电话',
  address         varchar(200)    DEFAULT NULL            COMMENT '地址',
  status          char(1)         DEFAULT '0'             COMMENT '状态（0正常 1停用）',
  del_flag        char(1)         DEFAULT '0'             COMMENT '删除标志',
  create_by       varchar(64)     DEFAULT ''              COMMENT '创建者',
  create_time     datetime                                COMMENT '创建时间',
  update_by       varchar(64)     DEFAULT ''              COMMENT '更新者',
  update_time     datetime                                COMMENT '更新时间',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (supplier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

-- 库存流水表
CREATE TABLE IF NOT EXISTS store_stock_record (
  record_id       bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  product_id      bigint(20)      NOT NULL                COMMENT '商品ID',
  record_type     char(1)         NOT NULL                COMMENT '类型（1入库 2出库 3盘点）',
  quantity        int(11)         NOT NULL                COMMENT '数量',
  before_stock    int(11)         DEFAULT 0               COMMENT '变动前库存',
  after_stock     int(11)         DEFAULT 0               COMMENT '变动后库存',
  supplier_id     bigint(20)      DEFAULT NULL            COMMENT '供应商ID',
  record_no       varchar(64)     DEFAULT NULL            COMMENT '单据编号',
  operate_type    char(1)         DEFAULT NULL            COMMENT '操作类型（1采购入库 2销售出库 3盘点盈亏 4退货入库 5其他）',
  create_by       varchar(64)     DEFAULT ''              COMMENT '操作人',
  create_time     datetime                                COMMENT '操作时间',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存流水表';

-- 会员表
CREATE TABLE IF NOT EXISTS store_member (
  member_id       bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '会员ID',
  member_name     varchar(50)     DEFAULT NULL            COMMENT '会员姓名',
  phone           varchar(20)     NOT NULL                COMMENT '手机号',
  gender          char(1)         DEFAULT '0'             COMMENT '性别（0男 1女 2未知）',
  birthday        date            DEFAULT NULL            COMMENT '生日',
  level_id        bigint(20)      DEFAULT NULL            COMMENT '会员等级ID',
  balance         decimal(10,2)   DEFAULT 0.00            COMMENT '余额',
  points          int(11)         DEFAULT 0               COMMENT '积分',
  total_amount    decimal(10,2)   DEFAULT 0.00            COMMENT '累计消费金额',
  total_orders    int(11)         DEFAULT 0               COMMENT '累计订单数',
  last_time       datetime        DEFAULT NULL            COMMENT '最后消费时间',
  status          char(1)         DEFAULT '0'             COMMENT '状态（0正常 1停用）',
  create_by       varchar(64)     DEFAULT ''              COMMENT '创建者',
  create_time     datetime                                COMMENT '创建时间',
  update_by       varchar(64)     DEFAULT ''              COMMENT '更新者',
  update_time     datetime                                COMMENT '更新时间',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (member_id),
  UNIQUE KEY uk_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员表';

-- 会员等级表
CREATE TABLE IF NOT EXISTS store_member_level (
  level_id        bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '等级ID',
  level_name      varchar(50)     NOT NULL                COMMENT '等级名称',
  min_points      int(11)         DEFAULT 0               COMMENT '最小积分',
  discount        decimal(3,2)    DEFAULT 1.00            COMMENT '折扣率',
  status          char(1)         DEFAULT '0'             COMMENT '状态',
  create_by       varchar(64)     DEFAULT ''              COMMENT '创建者',
  create_time     datetime                                COMMENT '创建时间',
  update_by       varchar(64)     DEFAULT ''              COMMENT '更新者',
  update_time     datetime                                COMMENT '更新时间',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (level_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员等级表';

-- 订单表
CREATE TABLE IF NOT EXISTS store_order (
  order_id        bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  order_no        varchar(64)     NOT NULL                COMMENT '订单编号',
  member_id       bigint(20)      DEFAULT NULL            COMMENT '会员ID',
  order_type      char(1)         DEFAULT '1'             COMMENT '订单类型（1销售 2退货）',
  order_status    char(1)         DEFAULT '0'             COMMENT '订单状态（0待支付 1已支付 2已取消 3已退款）',
  pay_type        char(1)         DEFAULT NULL            COMMENT '支付方式（1现金 2微信 3支付宝 4余额 5刷卡）',
  total_amount    decimal(10,2)   DEFAULT 0.00            COMMENT '订单总金额',
  discount_amount decimal(10,2)   DEFAULT 0.00            COMMENT '优惠金额',
  pay_amount      decimal(10,2)   DEFAULT 0.00            COMMENT '实付金额',
  points_used     int(11)         DEFAULT 0               COMMENT '使用积分',
  remark          varchar(500)    DEFAULT NULL            COMMENT '备注',
  create_by       varchar(64)     DEFAULT ''              COMMENT '创建者',
  create_time     datetime                                COMMENT '创建时间',
  update_by       varchar(64)     DEFAULT ''              COMMENT '更新者',
  update_time     datetime                                COMMENT '更新时间',
  PRIMARY KEY (order_id),
  UNIQUE KEY uk_order_no (order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单明细表
CREATE TABLE IF NOT EXISTS store_order_item (
  item_id         bigint(20)      NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  order_id        bigint(20)      NOT NULL                COMMENT '订单ID',
  product_id      bigint(20)      NOT NULL                COMMENT '商品ID',
  product_name    varchar(100)    NOT NULL                COMMENT '商品名称',
  specification   varchar(50)     DEFAULT NULL            COMMENT '规格',
  unit            varchar(20)     DEFAULT NULL            COMMENT '单位',
  sale_price      decimal(10,2)   NOT NULL                COMMENT '销售单价',
  quantity        int(11)         NOT NULL                COMMENT '数量',
  subtotal        decimal(10,2)   NOT NULL                COMMENT '小计金额',
  create_time     datetime                                COMMENT '创建时间',
  PRIMARY KEY (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 初始化会员等级数据
INSERT IGNORE INTO store_member_level (level_id, level_name, min_points, discount, status, create_by, create_time, remark) VALUES
(1, '普通会员', 0, 1.00, '0', 'admin', NOW(), '默认等级'),
(2, '银卡会员', 500, 0.95, '0', 'admin', NOW(), '消费满500积分'),
(3, '金卡会员', 2000, 0.90, '0', 'admin', NOW(), '消费满2000积分'),
(4, '钻石会员', 5000, 0.85, '0', 'admin', NOW(), '消费满5000积分');

-- 添加字典数据
INSERT IGNORE INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark) VALUES
('库存操作类型', 'stock_operate_type', '0', 'admin', NOW(), '库存流水操作类型'),
('支付方式', 'pay_type', '0', 'admin', NOW(), '订单支付方式');

INSERT IGNORE INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) VALUES
(1, '采购入库', '1', 'stock_operate_type', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(2, '销售出库', '2', 'stock_operate_type', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '盘点盈亏', '3', 'stock_operate_type', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(4, '退货入库', '4', 'stock_operate_type', '', 'info', 'N', '0', 'admin', NOW(), ''),
(5, '其他', '5', 'stock_operate_type', '', '', 'N', '0', 'admin', NOW(), '');

INSERT IGNORE INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) VALUES
(1, '现金', '1', 'pay_type', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(2, '微信', '2', 'pay_type', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '支付宝', '3', 'pay_type', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(4, '余额', '4', 'pay_type', '', 'danger', 'N', '0', 'admin', NOW(), ''),
(5, '刷卡', '5', 'pay_type', '', 'info', 'N', '0', 'admin', NOW(), '');
