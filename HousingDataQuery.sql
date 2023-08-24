SELECT *
FROM Portfolio..housing_data

--Standardize Date Format
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM Portfolio..housing_data

UPDATE housing_data
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE housing_data
Add SaleDateConverted Date

Update housing_data
SET SaleDateConverted = Convert(Date,saleDate)

--Populate Property Address Data that is NULL
Select Propertyaddress
From Portfolio..housing_data
Where Propertyaddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio..Housing_data a
JOIN Portfolio..Housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio..Housing_data a
JOIN Portfolio..Housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)
Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From Portfolio..housing_data

ALTER TABLE Portfolio..housing_data
Add PropertySplitAddress Nvarchar(255), PropertySplitCity Nvarchar(255)

Update Portfolio..housing_data
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1),
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

--Another Way to break out Address into Individual Columns
Select Parsename(replace(OwnerAddress, ',', '.') , 3), Parsename(replace(OwnerAddress, ',', '.') , 2), Parsename(replace(OwnerAddress, ',', '.') , 1)
From Portfolio..housing_data


ALTER TABLE Portfolio..housing_data
Add OwnerSplitAddress Nvarchar(255), OwnerSplitCity Nvarchar(255), OwnerSplitState Nvarchar(255)

Update Portfolio..housing_data
set OwnerSplitAddress = Parsename(replace(OwnerAddress, ',', '.') , 3),
	OwnerSplitCity = Parsename(replace(OwnerAddress, ',', '.') , 2),
	OwnerSplitState = Parsename(replace(OwnerAddress, ',', '.') , 1)

--Under Sold as Vacant Field, 1 = Yes and 0 = No
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio..housing_data
Group By SoldAsVacant
Order By 2

--Remove Duplicates entries
WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
		ORDER BY UniqueID) row_num
From Portfolio..housing_data
)
--DELETE
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress

--Total Count of Properties by City
Select PropertySplitCity, COUNT(PropertySplitCity) as TotalInCity
From Portfolio..housing_data
Group By PropertySplitCity
Order By TotalInCity DESC