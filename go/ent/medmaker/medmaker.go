// Code generated by ent, DO NOT EDIT.

package medmaker

import (
	"entgo.io/ent/dialect/sql"
)

const (
	// Label holds the string label denoting the medmaker type in the database.
	Label = "med_maker"
	// FieldID holds the string denoting the id field in the database.
	FieldID = "id"
	// FieldName holds the string denoting the name field in the database.
	FieldName = "name"
	// FieldURL holds the string denoting the url field in the database.
	FieldURL = "url"
	// FieldFaviconURL holds the string denoting the favicon_url field in the database.
	FieldFaviconURL = "favicon_url"
	// Table holds the table name of the medmaker in the database.
	Table = "med_makers"
)

// Columns holds all SQL columns for medmaker fields.
var Columns = []string{
	FieldID,
	FieldName,
	FieldURL,
	FieldFaviconURL,
}

// ValidColumn reports if the column name is valid (part of the table columns).
func ValidColumn(column string) bool {
	for i := range Columns {
		if column == Columns[i] {
			return true
		}
	}
	return false
}

// OrderOption defines the ordering options for the MedMaker queries.
type OrderOption func(*sql.Selector)

// ByID orders the results by the id field.
func ByID(opts ...sql.OrderTermOption) OrderOption {
	return sql.OrderByField(FieldID, opts...).ToFunc()
}

// ByName orders the results by the name field.
func ByName(opts ...sql.OrderTermOption) OrderOption {
	return sql.OrderByField(FieldName, opts...).ToFunc()
}

// ByURL orders the results by the url field.
func ByURL(opts ...sql.OrderTermOption) OrderOption {
	return sql.OrderByField(FieldURL, opts...).ToFunc()
}

// ByFaviconURL orders the results by the favicon_url field.
func ByFaviconURL(opts ...sql.OrderTermOption) OrderOption {
	return sql.OrderByField(FieldFaviconURL, opts...).ToFunc()
}
