package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
)

// MedSupply holds the schema definition for the MedSupply entity.
type MedSupply struct {
	ent.Schema
}

// Fields of the MedSupply.
func (MedSupply) Fields() []ent.Field {
	return []ent.Field{
		field.String("dose_form"),
		field.String("generic_name"),
		field.String("unit"),
		field.String("yj_code"),
		field.Int("yj_base"),
		field.String("maker"),
		field.String("brand_name"),
		field.String("sales_category"),
		field.String("shipment_status"),
		field.String("supply_status"),
		field.String("expect_lifting_status"),
		field.String("expect_lifting_description"),
		field.String("reason"),
		field.Time("updated_at"),
	}
}

// Edges of the MedSupply.
func (MedSupply) Edges() []ent.Edge {
	return nil
}

func (MedSupply) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("yj_base"),
	}
}
