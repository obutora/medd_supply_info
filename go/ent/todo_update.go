// Code generated by ent, DO NOT EDIT.

package ent

import (
	"context"
	"errors"
	"fmt"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/obutora/med_supply_info/ent/predicate"
	"github.com/obutora/med_supply_info/ent/todo"
)

// TodoUpdate is the builder for updating Todo entities.
type TodoUpdate struct {
	config
	hooks    []Hook
	mutation *TodoMutation
}

// Where appends a list predicates to the TodoUpdate builder.
func (tu *TodoUpdate) Where(ps ...predicate.Todo) *TodoUpdate {
	tu.mutation.Where(ps...)
	return tu
}

// SetName sets the "name" field.
func (tu *TodoUpdate) SetName(s string) *TodoUpdate {
	tu.mutation.SetName(s)
	return tu
}

// SetNillableName sets the "name" field if the given value is not nil.
func (tu *TodoUpdate) SetNillableName(s *string) *TodoUpdate {
	if s != nil {
		tu.SetName(*s)
	}
	return tu
}

// SetValue sets the "value" field.
func (tu *TodoUpdate) SetValue(i int) *TodoUpdate {
	tu.mutation.ResetValue()
	tu.mutation.SetValue(i)
	return tu
}

// SetNillableValue sets the "value" field if the given value is not nil.
func (tu *TodoUpdate) SetNillableValue(i *int) *TodoUpdate {
	if i != nil {
		tu.SetValue(*i)
	}
	return tu
}

// AddValue adds i to the "value" field.
func (tu *TodoUpdate) AddValue(i int) *TodoUpdate {
	tu.mutation.AddValue(i)
	return tu
}

// Mutation returns the TodoMutation object of the builder.
func (tu *TodoUpdate) Mutation() *TodoMutation {
	return tu.mutation
}

// Save executes the query and returns the number of nodes affected by the update operation.
func (tu *TodoUpdate) Save(ctx context.Context) (int, error) {
	return withHooks(ctx, tu.sqlSave, tu.mutation, tu.hooks)
}

// SaveX is like Save, but panics if an error occurs.
func (tu *TodoUpdate) SaveX(ctx context.Context) int {
	affected, err := tu.Save(ctx)
	if err != nil {
		panic(err)
	}
	return affected
}

// Exec executes the query.
func (tu *TodoUpdate) Exec(ctx context.Context) error {
	_, err := tu.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (tu *TodoUpdate) ExecX(ctx context.Context) {
	if err := tu.Exec(ctx); err != nil {
		panic(err)
	}
}

func (tu *TodoUpdate) sqlSave(ctx context.Context) (n int, err error) {
	_spec := sqlgraph.NewUpdateSpec(todo.Table, todo.Columns, sqlgraph.NewFieldSpec(todo.FieldID, field.TypeInt))
	if ps := tu.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := tu.mutation.Name(); ok {
		_spec.SetField(todo.FieldName, field.TypeString, value)
	}
	if value, ok := tu.mutation.Value(); ok {
		_spec.SetField(todo.FieldValue, field.TypeInt, value)
	}
	if value, ok := tu.mutation.AddedValue(); ok {
		_spec.AddField(todo.FieldValue, field.TypeInt, value)
	}
	if n, err = sqlgraph.UpdateNodes(ctx, tu.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{todo.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{msg: err.Error(), wrap: err}
		}
		return 0, err
	}
	tu.mutation.done = true
	return n, nil
}

// TodoUpdateOne is the builder for updating a single Todo entity.
type TodoUpdateOne struct {
	config
	fields   []string
	hooks    []Hook
	mutation *TodoMutation
}

// SetName sets the "name" field.
func (tuo *TodoUpdateOne) SetName(s string) *TodoUpdateOne {
	tuo.mutation.SetName(s)
	return tuo
}

// SetNillableName sets the "name" field if the given value is not nil.
func (tuo *TodoUpdateOne) SetNillableName(s *string) *TodoUpdateOne {
	if s != nil {
		tuo.SetName(*s)
	}
	return tuo
}

// SetValue sets the "value" field.
func (tuo *TodoUpdateOne) SetValue(i int) *TodoUpdateOne {
	tuo.mutation.ResetValue()
	tuo.mutation.SetValue(i)
	return tuo
}

// SetNillableValue sets the "value" field if the given value is not nil.
func (tuo *TodoUpdateOne) SetNillableValue(i *int) *TodoUpdateOne {
	if i != nil {
		tuo.SetValue(*i)
	}
	return tuo
}

// AddValue adds i to the "value" field.
func (tuo *TodoUpdateOne) AddValue(i int) *TodoUpdateOne {
	tuo.mutation.AddValue(i)
	return tuo
}

// Mutation returns the TodoMutation object of the builder.
func (tuo *TodoUpdateOne) Mutation() *TodoMutation {
	return tuo.mutation
}

// Where appends a list predicates to the TodoUpdate builder.
func (tuo *TodoUpdateOne) Where(ps ...predicate.Todo) *TodoUpdateOne {
	tuo.mutation.Where(ps...)
	return tuo
}

// Select allows selecting one or more fields (columns) of the returned entity.
// The default is selecting all fields defined in the entity schema.
func (tuo *TodoUpdateOne) Select(field string, fields ...string) *TodoUpdateOne {
	tuo.fields = append([]string{field}, fields...)
	return tuo
}

// Save executes the query and returns the updated Todo entity.
func (tuo *TodoUpdateOne) Save(ctx context.Context) (*Todo, error) {
	return withHooks(ctx, tuo.sqlSave, tuo.mutation, tuo.hooks)
}

// SaveX is like Save, but panics if an error occurs.
func (tuo *TodoUpdateOne) SaveX(ctx context.Context) *Todo {
	node, err := tuo.Save(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// Exec executes the query on the entity.
func (tuo *TodoUpdateOne) Exec(ctx context.Context) error {
	_, err := tuo.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (tuo *TodoUpdateOne) ExecX(ctx context.Context) {
	if err := tuo.Exec(ctx); err != nil {
		panic(err)
	}
}

func (tuo *TodoUpdateOne) sqlSave(ctx context.Context) (_node *Todo, err error) {
	_spec := sqlgraph.NewUpdateSpec(todo.Table, todo.Columns, sqlgraph.NewFieldSpec(todo.FieldID, field.TypeInt))
	id, ok := tuo.mutation.ID()
	if !ok {
		return nil, &ValidationError{Name: "id", err: errors.New(`ent: missing "Todo.id" for update`)}
	}
	_spec.Node.ID.Value = id
	if fields := tuo.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, todo.FieldID)
		for _, f := range fields {
			if !todo.ValidColumn(f) {
				return nil, &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
			}
			if f != todo.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, f)
			}
		}
	}
	if ps := tuo.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := tuo.mutation.Name(); ok {
		_spec.SetField(todo.FieldName, field.TypeString, value)
	}
	if value, ok := tuo.mutation.Value(); ok {
		_spec.SetField(todo.FieldValue, field.TypeInt, value)
	}
	if value, ok := tuo.mutation.AddedValue(); ok {
		_spec.AddField(todo.FieldValue, field.TypeInt, value)
	}
	_node = &Todo{config: tuo.config}
	_spec.Assign = _node.assignValues
	_spec.ScanValues = _node.scanValues
	if err = sqlgraph.UpdateNode(ctx, tuo.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{todo.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{msg: err.Error(), wrap: err}
		}
		return nil, err
	}
	tuo.mutation.done = true
	return _node, nil
}
