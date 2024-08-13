package main

import (
	"context"
	"fmt"
	"log"
	"strconv"
	"strings"
	"sync"

	"entgo.io/ent/dialect"
	"github.com/obutora/med_supply_info/ent"
	"github.com/obutora/med_supply_info/entity"
	_ "github.com/xiaoqidun/entps"
	"github.com/xuri/excelize/v2"

	"github.com/gocolly/colly"

	"net/url"
)

const filePath = "../report.xlsx"

func main() {
	client, err := ent.Open(dialect.SQLite, "file:../flutter_med_supply/assets/med.db")
	if err != nil {
		log.Fatalf("failed opening connection to sqlite: %v", err)
	}
	defer client.Close()
	ctx := context.Background()
	// 自動マイグレーションツールを実行して、すべてのスキーマリソースを作成します。
	if err := client.Schema.Create(ctx); err != nil {
		log.Fatalf("failed creating schema resources: %v", err)
	}

	f, err := excelize.OpenFile(filePath)
	if err != nil {
		fmt.Printf("open file error: %v\n", err)
	}

	defer f.Close()

	ms, err := getMedSupplyFromFile(f)
	if err != nil {
		fmt.Printf("getMedSupplyFromFile error: %v\n", err)
	}

	fmt.Printf("medSupplies: %v\n", len(ms))

	err = InsertMedSupply(ctx, client, ms)
	if err != nil {
		fmt.Printf("InsertMed error: %v\n", err)
	}

	mm, err := getMedMakerFromFile(f)
	if err != nil {
		log.Fatalf("getMedMakerFromFile error: %v\n", err)
	}
	fmt.Printf("medMakers: %v\n", len(mm))

	// 重複を排除
	mm = uniqueMedMakersByName(mm)

	err = InsertMedMaker(ctx, client, mm)
	if err != nil {
		log.Fatalf("InsertMedMaker error: %v\n", err)
	}

	// f := GetFaviconUrl("https://www.nichiiko.co.jp/")
	// fmt.Printf("faviconUrl: %v\n", f)

}

func uniqueMedMakersByName(medMakers []entity.MedMaker) []entity.MedMaker {
	uniqueNames := make(map[string]struct{})
	var result []entity.MedMaker

	for _, medMaker := range medMakers {
		if _, ok := uniqueNames[medMaker.Name]; !ok {
			uniqueNames[medMaker.Name] = struct{}{}
			result = append(result, medMaker)
		}
	}

	return result
}

func getMedSupplyFromFile(f *excelize.File) ([]entity.MedSupply, error) {
	// 薬剤情報取得
	s1Name := f.GetSheetName(0)
	rows, err := f.GetRows(s1Name)
	if err != nil {
		return nil, fmt.Errorf("get MedSupply rows error: %v\n", err)
	}

	defer f.Close()

	var medSupplies []entity.MedSupply
	for i, row := range rows {
		if i == 0 || i == 1 {
			continue
		}
		d := entity.MedSupplyFromRow(row)
		medSupplies = append(medSupplies, d)
	}
	return medSupplies, nil
}

func getMedMakerFromFile(f *excelize.File) ([]entity.MedMaker, error) {
	s4Name := f.GetSheetName(3)
	rows, err := f.GetRows(s4Name)
	if err != nil {
		return nil, fmt.Errorf("get rows error: %v", err)
	}

	medMakers := make([]entity.MedMaker, 0, len(rows)-1)
	errors := make(chan error, len(rows)-1)
	var wg sync.WaitGroup

	for _, row := range rows[1:] { // Skip the header row
		if row[1] == "" {
			continue
		}

		wg.Add(1)
		go func(row []string) {
			defer wg.Done()

			var d entity.MedMaker
			if len(row) == 3 {
				url := strings.Split(row[2], "\n")
				d = entity.MedMaker{
					Name:       row[1],
					Url:        url[0],
					FaviconUrl: GetFaviconUrl(url[0]),
				}
			} else {
				d = entity.MedMaker{
					Name:       row[1],
					Url:        "",
					FaviconUrl: "",
				}
			}

			medMakers = append(medMakers, d)
		}(row)
	}

	wg.Wait()
	close(errors)

	for err := range errors {
		if err != nil {
			return nil, err
		}
	}

	for _, m := range medMakers {
		fmt.Printf("medmaker: %v\n", m)
	}

	return medMakers, nil
}

func InsertMedSupply(ctx context.Context, client *ent.Client, medSupplies []entity.MedSupply) error {

	var builder []*ent.MedSupplyCreate
	for _, v := range medSupplies {
		yjBase, _ := strconv.Atoi(v.YjBase)

		c := client.MedSupply.Create().
			SetDoseForm(v.DoseForm).
			SetGenericName(v.GenericName).
			SetUnit(v.Unit).
			SetYjCode(v.YjCode).
			SetYjBase(yjBase).
			SetMaker(v.Maker).
			SetBrandName(v.BrandName).
			SetSalesCategory(v.SalesCategory).
			SetShipmentStatus(v.ShipmentStatus).
			SetSupplyStatus(v.SupplyStatus).
			SetExpectLiftingStatus(v.ExpectLiftingStatus).
			SetExpectLiftingDescription(v.ExpectLiftingDescription).
			SetReason(v.Reason).
			SetUpdatedAt(v.UpdatedAt)

		builder = append(builder, c)
	}

	// 500個ずつに分割して登録
	for i := 0; i < len(builder); i += 500 {
		end := i + 500
		if end > len(builder) {
			end = len(builder)
		}
		_, err := client.MedSupply.CreateBulk(builder[i:end]...).Save(ctx)
		if err != nil {
			log.Fatalf("failed creating medSupply: %v", err)
		}
	}
	return nil
}

func InsertMedMaker(ctx context.Context, client *ent.Client, medMakers []entity.MedMaker) error {

	var builder []*ent.MedMakerCreate
	for _, v := range medMakers {
		c := client.MedMaker.Create().
			SetName(v.Name).
			SetURL(v.Url).
			SetFaviconURL(v.FaviconUrl)
		builder = append(builder, c)
	}

	// 500個ずつに分割して登録
	for i := 0; i < len(builder); i += 500 {
		end := i + 500
		if end > len(builder) {
			end = len(builder)
		}
		_, err := client.MedMaker.CreateBulk(builder[i:end]...).Save(ctx)
		if err != nil {
			log.Fatalf("failed creating medMaker: %v", err)
		}
	}
	return nil
}

func GetFaviconUrl(url string) string {
	c := colly.NewCollector()

	var faviconUrl string

	c.OnHTML("link", func(e *colly.HTMLElement) {
		if faviconUrl != "" {
			return
		}

		if e.Attr("rel") == "icon" || e.Attr("rel") == "shortcut icon" {
			favicon := e.Attr("href")
			faviconUrl = toAbsoluteFaviconUrl(url, favicon)
			// fmt.Printf("faviconUrl: %v\n", faviconUrl)
		}
	})
	c.Visit(url)
	fmt.Printf("faviconUrl: %v\n", faviconUrl)
	return faviconUrl
}

func toAbsoluteFaviconUrl(fetchUrl string, faviconUrl string) string {
	if faviconUrl == "" {
		return ""
	}

	if strings.HasPrefix(faviconUrl, "http") {
		return faviconUrl
	}

	uri, err := url.Parse(fetchUrl)
	if err != nil {
		fmt.Printf("url.Parse error: %v\n", err)
		return ""
	}

	originString := uri.Scheme + "://" + uri.Host
	origin, _ := url.Parse(originString)

	return origin.JoinPath(faviconUrl).String()
}
