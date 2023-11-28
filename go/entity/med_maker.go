package entity

import "fmt"

type MedMaker struct {
	Name string
	Url  string
}

func (m *MedMaker) ToString() string {
	return fmt.Sprintf("Name: %s, Url: %s", m.Name, m.Url)
}
