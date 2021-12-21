
-------------------------------------

--Cleaning Data In SQL Queries

SELECT*
FROM PortfolioProject.dbo.NashvilleHousingProject
---------------------------------------------

--Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousingProject

UPDATE NashvilleHousingProject
SET SaleDate =CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousingProject
Add SaleDateConverted Date;

UPDATE NashvilleHousingProject
SET SaleDateConverted =CONVERT(Date, SaleDate)


--------------------------------------------------------------------------

---Populate Property Address Data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousingProject
--WHERE PropertyAddress is null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousingProject a
JOIN PortfolioProject.dbo.NashvilleHousingProject b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousingProject a
JOIN PortfolioProject.dbo.NashvilleHousingProject b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


--------------------------------------------------------------------------------------------
---Breaking Out Address into Individual Columns( Address, city and state)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousingProject
--WHERE PropertyAddress is null

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address

FROM PortfolioProject.dbo.NashvilleHousingProject


ALTER TABLE NashvilleHousingProject
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousingProject
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousingProject
Add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousingProject
SET PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 


SELECT *
FROM PortfolioProject.dbo.NashvilleHousingProject



SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousingProject

SELECT PARSENAME(REPLACE(OwnerAddress, ',' , '.' ), 3)
,  PARSENAME(REPLACE(OwnerAddress, ',' , '.' ), 2)
,  PARSENAME(REPLACE(OwnerAddress, ',' , '.' ), 1)
FROM PortfolioProject.dbo.NashvilleHousingProject


ALTER TABLE NashvilleHousingProject
Add OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousingProject
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ), 3)

ALTER TABLE NashvilleHousingProject
Add OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousingProject
SET OwnerSplitCity  =  PARSENAME(REPLACE(OwnerAddress, ',' , '.' ), 2)
 

ALTER TABLE NashvilleHousingProject
Add OwnerSplitState nvarchar(255);

UPDATE NashvilleHousingProject
SET OwnerSplitState  =  PARSENAME(REPLACE(OwnerAddress, ',' , '.' ), 1)



--------------------------------------------------------------------------------------
---Change Y and N into Yes and No in 'SoldAsVacant'field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousingProject
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant
 , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject.dbo.NashvilleHousingProject


UPDATE NashvilleHousingProject
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



---------------------------------------------------------------------------------
---Remove Duplicates

WITH RowNumCTE AS(
SELECT *, 
        ROW_NUMBER() OVER(
        PARTITION BY ParcelID,
                             PropertyAddress,
			                 SalePrice,
			                 SaleDate,
			                 LegalReference
			                 ORDER BY 
			                 UniqueID
			                  ) row_num

FROM PortfolioProject.dbo.NashvilleHousingProject
--ORDER BY ParcelID
)

SELECT*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



----------------------------------------------------------------------------------
---DELETE UNUSED COLUMNS

SELECT *
FROM PortfolioProject.dbo.NashvilleHousingProject


ALTER TABLE PortfolioProject.dbo.NashvilleHousingProject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousingProject
DROP COLUMN SaleDate
























