import useSWR from "swr"

const URL = "https://api.coingecko.com/api/v3/coins/matic-network?localization=false&tickers=false&community_data=false&developer_data=false&sparkline=false"
export const COURSE_PRICE = 1

const fetcher = async url => {
  const res = await fetch(url)
  const json = await res.json()

  return json.market_data.current_price.usd ?? null
}

export const useEthPrice = () => {
  const { data, ...rest } = useSWR(
    URL,
    fetcher,
    { refreshInterval: 10000 }
  )
//console.log(data)
  const perItem = (data && (COURSE_PRICE)) ?? null
  return { eth: { data, perItem, ...rest}}
}

