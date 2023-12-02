package entity

import "fmt"

type MedMaker struct {
	Name       string
	Url        string
	FaviconUrl string
}

func (m *MedMaker) ToString() string {
	return fmt.Sprintf("Name: %s, Url: %s, FaviconUrl: %s", m.Name, m.Url, m.FaviconUrl)
}
