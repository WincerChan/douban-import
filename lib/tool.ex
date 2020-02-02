defmodule Tool do
  @douban_id Application.get_env(:douban_show, :doubanid)
  def concat_url_by_type(category) do
    "https://#{category}.douban.com/people/#{@douban_id}/collect"
  end

  def fetch_pages(category) do
    concat_url_by_type(category)
    |> parse_content
    |> Floki.find(".paginator > a:last-of-type")
    |> Floki.text(deep: false)
    |> to_integer
    |> decr
  end

  defp to_integer(nil) do
    0
  end

  defp to_integer("") do
    0
  end

  defp to_integer(str) do
    String.to_integer(str)
  end

  def url(movie_item) do
    movie_item
    |> Floki.find(".nbg")
    |> Floki.attribute("href")
    |> Floki.text(deep: false)
  end

  def tags(movie_item) do
    movie_item
    |> Floki.find(".tags")
    |> Floki.text(deep: false)
    |> String.split(" ")
    |> tl
  end

  def cover(movie_item) do
    movie_item
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> hd
  end

  def get_rating(rating_str) do
    to_integer(rating_str)
  end

  def comment(movie_item) do
    movie_item
    |> Floki.find(".comment")
    |> Floki.text(deep: false)
  end

  def parse_content(url) do
    HTTPoison.get(url, %{}, hackney: [cookie: ["bid=FMmHbs6EbzY"]])
    |> get_resp
    |> elem(1)
  end

  defp get_resp({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Floki.parse_document(body)
  end

  defp get_resp(_) do
    Floki.parse_document("")
  end

  def mute_output(_) do
  end

  def decr(num), do: num - 1
end