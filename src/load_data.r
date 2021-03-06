zoning_df = read.csv('../data/zoning.csv')
listing_df = read.csv('../data/listing.csv')
sale_df = read.csv('../data/sale.csv')

numeric_updated_df = read.csv('../data/numeric_updated_df.csv')
final_ames_df = read.csv('../data/final_ames_df.csv')
#top_ten_df = read.csv('../data/top_ten_df.csv')

housing_df = merge(zoning_df, listing_df, by="Id")
housing_df = merge(housing_df, sale_df, by="Id")

count_empty_values <- function (feature) {
    empty_string_mask = housing_df[feature] == ""
    return(length(housing_df[feature][empty_string_mask]))
}

count_empty_total <- function (){
    for (feature in colnames(housing_df)) {
        empty_count <- count_empty_values(feature)
        if (empty_count > 0) {
            print(paste(feature, empty_count))        
        }
    }
}

rownames(housing_df) <- housing_df$Id 
housing_df$Id <- NULL
housing_df$X <- NULL

housing_df$MSSubClass <- as.factor(housing_df$MSSubClass)
housing_df$OverallQual <- as.factor(housing_df$OverallQual)
housing_df$OverallCond <- as.factor(housing_df$OverallCond)
housing_df$BsmtFullBath <- as.factor(housing_df$BsmtFullBath)
housing_df$BsmtHalfBath <- as.factor(housing_df$BsmtHalfBath)
housing_df$FullBath <- as.factor(housing_df$FullBath)
housing_df$HalfBath <- as.factor(housing_df$HalfBath)
housing_df$BedroomAbvGr <- as.factor(housing_df$BedroomAbvGr)
housing_df$KitchenAbvGr <- as.factor(housing_df$KitchenAbvGr)
housing_df$TotRmsAbvGrd <- as.factor(housing_df$TotRmsAbvGrd)
housing_df$Fireplaces <- as.factor(housing_df$Fireplaces)
housing_df$GarageCars <- as.factor(housing_df$GarageCars)
housing_df$MoSold <- as.factor(housing_df$MoSold)
housing_df$YrSold <- as.factor(housing_df$YrSold)

mean_LotFrontage <- mean(housing_df$LotFrontage, na.rm=T)
mean_MasVnrArea <- mean(housing_df$MasVnrArea, na.rm=T)
mean_GarageYrBlt <- mean(housing_df$GarageYrBlt, na.rm=T)

housing_df$LotFrontage[is.na(housing_df$LotFrontage)] <- mean_LotFrontage
housing_df$MasVnrArea[is.na(housing_df$MasVnrArea)] <- mean_MasVnrArea
housing_df$GarageYrBlt[is.na(housing_df$GarageYrBlt)] <- mean_GarageYrBlt

empty_means_without <-c("Alley","BsmtQual","BsmtCond","BsmtExposure","BsmtFinType1",
                        "BsmtFinType2", "FireplaceQu","GarageType","GarageFinish",
                        "GarageQual","GarageCond","PoolQC","Fence","MiscFeature")

empty_means_NA <- c("MasVnrType","Electrical")

replace_empty_with_without <- function(feature) {
    levels(feature) <- c(levels(feature), "without")
    empty_string_mask <- feature == ''
    feature[empty_string_mask] <- "without"
    return(feature)
}

replace_empty_with_NA <- function(feature) {
    levels(feature) <- c(levels(feature), NA)
    empty_string_mask <- feature == ''
    feature[empty_string_mask] <- NA
    return(feature)
}

for (feature in empty_means_without) {
    housing_df[,feature] <- replace_empty_with_without(housing_df[,feature])
}

for (feature in empty_means_NA) {
    housing_df[,feature] <- replace_empty_with_NA(housing_df[,feature])
}

housing_df <- na.omit(housing_df)

numeric_df = Filter(is.numeric, housing_df)
sale_price <- numeric_df$SalePrice
#numeric_df$SalePrice <- NULL
numeric_log_df = log(numeric_df+0.000001)
numeric_log_sc_df = data.frame(scale(numeric_log_df))
categoric_df = Filter(is.factor, housing_df)