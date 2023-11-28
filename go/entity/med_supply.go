package entity

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
	"time"
)

type MedSupply struct {
	DoseForm                 string
	GenericName              string
	Unit                     string
	YjCode                   string
	Maker                    string
	BrandName                string
	SalesCategory            *string
	ShipmentStatus           *string
	SupplyStatus             *string
	ExpectLiftingStatus      *string
	ExpectLiftingDescription *string
	Reason                   *string
	UpdatedAt                *time.Time
}

func MedSupplyFromRow(row []string) MedSupply {
	t := GetTime(row[13])
	ship := ConvertShipStatus(row[7])
	sup := ConvertSupplyStatus(row[8])
	ls := ConvertLiftingStatus(row[10])
	r := ConvertReason(row[12])

	return MedSupply{
		DoseForm:                 row[0],
		GenericName:              row[1],
		Unit:                     row[2],
		YjCode:                   row[3],
		Maker:                    row[4],
		BrandName:                row[5],
		SalesCategory:            &row[6],
		ShipmentStatus:           &ship,
		SupplyStatus:             &sup,
		ExpectLiftingStatus:      &ls,
		ExpectLiftingDescription: &row[11],
		Reason:                   &r,
		UpdatedAt:                &t,
	}
}

func GetTime(timeString string) time.Time {
	re, _ := regexp.Compile(`(\d{4})年(\d{1,2})月(\d{1,2})日`)
	d := re.FindAllStringSubmatch(timeString, -1)[0]

	y, _ := strconv.Atoi(d[1])
	m, _ := strconv.Atoi(d[2])
	da, _ := strconv.Atoi(d[3])

	return time.Date(y, time.Month(m), da, 0, 0, 0, 0, time.UTC)
}

func ConvertShipStatus(s string) string {
	if s == "" {
		return ""
	}

	if strings.Contains(s, "Aプラス") {
		return "A+"
	}

	if strings.Contains(s, "A") {
		return "A"
	}

	if strings.Contains(s, "B") {
		return "B"
	}

	if strings.Contains(s, "C") {
		return "C"
	}

	if strings.Contains(s, "D") {
		return "D"
	}

	return ""
}

func ConvertSupplyStatus(s string) string {
	if s == "" {
		return ""
	}

	if strings.Contains(s, "①") {
		return "normal"
	}

	if strings.Contains(s, "②") {
		return "limitedSelf"
	}

	if strings.Contains(s, "③") {
		return "limitedOpponent"
	}

	if strings.Contains(s, "④") {
		return "limitedOther"
	}

	if strings.Contains(s, "⑤") {
		return "stop"
	}

	return ""
}

func ConvertLiftingStatus(s string) string {
	if s == "" {
		return ""
	}

	if strings.Contains(s, "ア") {
		return "promising"
	}

	if strings.Contains(s, "イ") {
		return "promisingNot"
	}

	// ウ、エ、未記入すべてpendingにしておく
	return "pending"
}

func ConvertReason(s string) string {
	if s == "" {
		return ""
	}

	if strings.Contains(s, "１") {
		return "increaseDemand"
	}

	if strings.Contains(s, "２") {
		return "materialShortage"
	}

	if strings.Contains(s, "３") {
		return "manufacturingTrouble"
	}

	if strings.Contains(s, "４") {
		return "qualityTrouble"
	}

	if strings.Contains(s, "５") {
		return "administrativeAction"
	}

	if strings.Contains(s, "６") {
		return "remove"
	}

	// 7, nil は未記入としておく
	return ""
}

func (m MedSupply) ToString() string {
	return fmt.Sprintf("DoseForm: %v, GenericName: %v, Unit: %v, YjCode: %v, Maker: %v, BrandName: %v, SalesCategory: %v, ShipmentStatus: %v, SupplyStatus: %v, ExpectLiftingStatus: %v, ExpectLiftingDescription: %v, Reason: %v, UpdatedAt: %v",
		m.DoseForm, m.GenericName, m.Unit, m.YjCode, m.Maker, m.BrandName, *m.SalesCategory, *m.ShipmentStatus, *m.SupplyStatus, *m.ExpectLiftingStatus, *m.ExpectLiftingDescription, *m.Reason, *m.UpdatedAt)
}
