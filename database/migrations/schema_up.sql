CREATE TABLE IF NOT EXISTS "users_auth0" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"auth_id" VARCHAR(255) NOT NULL UNIQUE,
	"created_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "users" (
  "id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_auth0_id" UUID NOT NULL,
  "name" VARCHAR(255) NOT NULL,
	"email" VARCHAR(255) NOT NULL UNIQUE,
	"password" VARCHAR(255) NOT NULL,
  "is_active" BOOLEAN NOT NULL DEFAULT false,
	"is_verified" BOOLEAN NOT NULL DEFAULT false,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_auth0_id") REFERENCES "users_auth0"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,

);

CREATE TABLE IF NOT EXISTS "roles" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR(255) NOT NULL UNIQUE,
	"is_active" BOOLEAN NOT NULL DEFAULT true,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "users_roles" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"role_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "wallet_sources" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR(255) NOT NULL UNIQUE,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "wallet_currencies" {
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR(255) NOT NULL UNIQUE,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
}

CREATE TABLE IF NOT EXISTS "user_wallets" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"wallet_source_id" UUID NOT NULL,
	"wallet_currency_id" UUID NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"balance" DECIMAL NOT NULL DEFAULT 0,
	"initial_balance" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("wallet_source_id") REFERENCES "wallet_sources"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("wallet_currency_id") REFERENCES "wallet_currencies"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "transaction_periods" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR(255) NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "user_budgets" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"transaction_period_id" UUID NOT NULL,
	"is_active" BOOLEAN NOT NULL DEFAULT true,
	"description" VARCHAR(255),
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("transaction_period_id") REFERENCES "transaction_periods"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "user_goals" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"transaction_period_id" UUID NOT NULL,
	"is_completed" BOOLEAN NOT NULL DEFAULT false,
	"is_active" BOOLEAN NOT NULL DEFAULT true,
	"description" VARCHAR(255),
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("transaction_period_id") REFERENCES "transaction_periods"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "goal_transactions" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_goal_id" UUID NOT NULL,
	"user_wallet_id" UUID NOT NULL,
	"type" ENUM('topup', 'withdraw') NOT NULL,
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_goal_id") REFERENCES "user_goals"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("user_wallet_id") REFERENCES "user_wallets"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "user_transfers" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"sender_wallet_id" UUID NOT NULL,
	"receiver_wallet_id" UUID NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"description" VARCHAR(255),
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("sender_wallet_id") REFERENCES "user_wallets"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("receiver_wallet_id") REFERENCES "user_wallets"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "user_incomes" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"user_wallet_id" UUID NOT NULL,
	"description" VARCHAR(255),
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("user_wallet_id") REFERENCES "user_wallets"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS "user_outcomes" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"user_wallet_id" UUID NOT NULL,
	"user_budget_id" UUID NOT NULL,
	"description" VARCHAR(255),
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("user_wallet_id") REFERENCES "user_wallets"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY ("user_budget_id") REFERENCES "user_budgets"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);
