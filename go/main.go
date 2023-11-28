package main

import (
	"fmt"
	"strings"

	"github.com/obutora/med_supply_info/entity"
	"github.com/xuri/excelize/v2"
)

func main() {
	f, err := excelize.OpenFile("../report.xlsx")
	if err != nil {
		fmt.Printf("open file error: %v\n", err)
	}

	defer f.Close()

	// 薬剤情報取得
	s1Name := f.GetSheetName(0)
	rows, err := f.GetRows(s1Name)
	if err != nil {
		fmt.Printf("get rows error: %v\n", err)
	}

	for i, row := range rows {

		// TODO: Remove Upper Limit
		if i == 0 || i == 1 || i > 47 {
			continue
		}
		d := entity.MedSupplyFromRow(row)
		fmt.Printf("d: %v\n", d.ToString())
	}

	// メーカー名・HP取得
	s4Name := f.GetSheetName(3)
	rows, err = f.GetRows(s4Name)
	if err != nil {
		fmt.Printf("get rows error: %v\n", err)
	}

	for i, row := range rows {
		if i == 0 || i > 50 {
			continue
		}
		if row[1] == "" {
			continue
		}

		var d MedMaker
		if len(row) == 3 {
			url := strings.Split(row[2], "\n")

			d = MedMaker{
				Name: row[1],
				Url:  url[0],
			}
		} else {

			d = MedMaker{
				Name: row[1],
				Url:  "",
			}
		}

		fmt.Printf("%v\n", d.ToString())
	}

	// s := "2020年12月31日"
	// re, _ := regexp.Compile(`(\d{4})年(\d{1,2})月(\d{1,2})日`)
	// fmt.Println(re.FindAllStringSubmatch(s, -1)[0][1])
}

type MedMaker struct {
	Name string
	Url  string
}

func (m *MedMaker) ToString() string {
	return fmt.Sprintf("Name: %s, Url: %s", m.Name, m.Url)
}
