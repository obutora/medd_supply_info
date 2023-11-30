package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
)

// MedMaker holds the schema definition for the MedMaker entity.
type MedMaker struct {
	ent.Schema
}

// Fields of the MedMaker.
func (MedMaker) Fields() []ent.Field {
	return []ent.Field{
		field.String("name"),
		field.String("url"),
	}
}

// Edges of the MedMaker.
func (MedMaker) Edges() []ent.Edge {
	return nil
}

func (MedMaker) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("name").
			Unique(),
	}
}
