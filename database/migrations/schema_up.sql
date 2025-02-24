CREATE TABLE "users" (
  "id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" VARCHAR NOT NULL,
	"email" VARCHAR NOT NULL UNIQUE,
	"password" VARCHAR NOT NULL,
  "is_active" BOOLEAN NOT NULL DEFAULT false,
	"is_verified" BOOLEAN NOT NULL DEFAULT false,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE users_auth0 (
	id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	auth_id VARCHAR NOT NULL UNIQUE,
	created_at TIMESTAMP NOT NULL DEFAULT now(),
	updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "roles" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR NOT NULL UNIQUE,
	"is_active" BOOLEAN NOT NULL DEFAULT true,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "user_roles" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"role_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
	FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE CASCADE
);

CREATE TABLE "wallet_types" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR NOT NULL UNIQUE,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "user_wallets" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"name" VARCHAR NOT NULL,
	"wallet_type_id" UUID NOT NULL,
	"balance" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
	FOREIGN KEY ("wallet_type_id") REFERENCES "wallet_types"("id") ON DELETE CASCADE
);

CREATE TABLE "transaction_types" (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE budget_categories (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE user_budgets (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"name" VARCHAR NOT NULL,
	"description" VARCHAR NOT NULL,
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"user_id" UUID NOT NULL,
	"budget_category_id" UUID NOT NULL,
	"transaction_type_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
	FOREIGN KEY ("budget_category_id") REFERENCES "budget_categories"("id") ON DELETE CASCADE
	FOREIGN KEY ("transaction_type_id") REFERENCES "transaction_types"("id") ON DELETE CASCADE
);

CREATE TABLE user_transactions (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_id" UUID NOT NULL,
	"amount" DECIMAL NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
);

CREATE TABLE user_wallet_transactions (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_wallet_id" UUID NOT NULL,
	"user_transaction_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_wallet_id") REFERENCES "user_wallets"("id") ON DELETE CASCADE,
	FOREIGN KEY ("user_transaction_id") REFERENCES "user_transactions"("id") ON DELETE CASCADE
);

CREATE TABLE user_budget_transactions (
	"id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	"user_budget_id" UUID NOT NULL,
	"user_transaction_id" UUID NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT now(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT now(),
	FOREIGN KEY ("user_budget_id") REFERENCES "user_budgets"("id") ON DELETE CASCADE,
	FOREIGN KEY ("user_transaction_id") REFERENCES "user_transactions"("id") ON DELETE CASCADE
);
