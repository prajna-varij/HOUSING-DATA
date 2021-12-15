-- Cleaning Data in SQL Queries

Select * 
FROM PortfolioProject.dbo.Sheet1


Select SaleDate, CONVERT (Date,SaleDate) 
FROM PortfolioProject.dbo.Sheet1

Update Sheet1
SET SaleDate = CONVERT (Date,SaleDate) 

ALTER TABLE Sheet1
Add SaleDateConverted_1 Date;

Update Sheet1
SET SaleDateConverted_1 = CONVERT (Date,SaleDate) 

Select SaleDateConverted_1, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.Sheet1


-- Property Address removing NULL VALUES

SELECT PropertyAddress
FROM PortfolioProject.dbo.Sheet1
WHERE PropertyAddress is null

SELECT *
FROM PortfolioProject.dbo.Sheet1
--WHERE PropertyAddress is null
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.Sheet1 a
JOIN PortfolioProject.dbo.Sheet1 b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.Sheet1 a
JOIN PortfolioProject.dbo.Sheet1 b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Separating Address into Individual Coloums

SELECT PropertyAddress
FROM PortfolioProject.dbo.Sheet1

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress))as Address
FROM PortfolioProject.dbo.Sheet1

ALTER TABLE Sheet1
Add PropertySplitAddress NVARCHAR(255);

Update Sheet1
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Sheet1
Add PropertySplitCity NVARCHAR(255);

Update Sheet1
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1,LEN(PropertyAddress))

Select *

FROM PortfolioProject.dbo.Sheet1

--OWNER_ADDRESS

Select OwnerAddress

FROM PortfolioProject.dbo.Sheet1

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3) 
,PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

FROM PortfolioProject.dbo.Sheet1


ALTER TABLE Sheet1
Add OwnerSplitAddress NVARCHAR(255);

Update Sheet1
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE Sheet1
Add OwnerSplitCity NVARCHAR(255);

Update Sheet1
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE Sheet1
Add OwnerSplitState NVARCHAR(255);

Update Sheet1
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

SELECT *
FROM PortfolioProject.dbo.Sheet1

-- Convert Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.Sheet1
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	   WHEN SoldasVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.Sheet1

UPDATE Sheet1
SET SoldAsVacant = CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	   WHEN SoldasVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- REMOVE DUPLICATES
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.Sheet1
)
DELETE 
FROM RowNumCTE
WHERE row_num >1


-- Deleting Unused Columns

Select *
FROM PortfolioProject.dbo.Sheet1

ALTER TABLE PortfolioProject.dbo.Sheet1
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject.dbo.Sheet1
DROP COLUMN SaleDate
