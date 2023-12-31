// Code generated by ent, DO NOT EDIT.

package ent

import (
	"context"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/obutora/med_supply_info/ent/medmaker"
	"github.com/obutora/med_supply_info/ent/predicate"
)

// MedMakerDelete is the builder for deleting a MedMaker entity.
type MedMakerDelete struct {
	config
	hooks    []Hook
	mutation *MedMakerMutation
}

// Where appends a list predicates to the MedMakerDelete builder.
func (mmd *MedMakerDelete) Where(ps ...predicate.MedMaker) *MedMakerDelete {
	mmd.mutation.Where(ps...)
	return mmd
}

// Exec executes the deletion query and returns how many vertices were deleted.
func (mmd *MedMakerDelete) Exec(ctx context.Context) (int, error) {
	return withHooks(ctx, mmd.sqlExec, mmd.mutation, mmd.hooks)
}

// ExecX is like Exec, but panics if an error occurs.
func (mmd *MedMakerDelete) ExecX(ctx context.Context) int {
	n, err := mmd.Exec(ctx)
	if err != nil {
		panic(err)
	}
	return n
}

func (mmd *MedMakerDelete) sqlExec(ctx context.Context) (int, error) {
	_spec := sqlgraph.NewDeleteSpec(medmaker.Table, sqlgraph.NewFieldSpec(medmaker.FieldID, field.TypeInt))
	if ps := mmd.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	affected, err := sqlgraph.DeleteNodes(ctx, mmd.driver, _spec)
	if err != nil && sqlgraph.IsConstraintError(err) {
		err = &ConstraintError{msg: err.Error(), wrap: err}
	}
	mmd.mutation.done = true
	return affected, err
}

// MedMakerDeleteOne is the builder for deleting a single MedMaker entity.
type MedMakerDeleteOne struct {
	mmd *MedMakerDelete
}

// Where appends a list predicates to the MedMakerDelete builder.
func (mmdo *MedMakerDeleteOne) Where(ps ...predicate.MedMaker) *MedMakerDeleteOne {
	mmdo.mmd.mutation.Where(ps...)
	return mmdo
}

// Exec executes the deletion query.
func (mmdo *MedMakerDeleteOne) Exec(ctx context.Context) error {
	n, err := mmdo.mmd.Exec(ctx)
	switch {
	case err != nil:
		return err
	case n == 0:
		return &NotFoundError{medmaker.Label}
	default:
		return nil
	}
}

// ExecX is like Exec, but panics if an error occurs.
func (mmdo *MedMakerDeleteOne) ExecX(ctx context.Context) {
	if err := mmdo.Exec(ctx); err != nil {
		panic(err)
	}
}
