--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Prelude hiding (div)
import Control.Monad
import Data.Monoid
import Data.List (uncons)
import Data.Maybe (fromMaybe)
import Hakyll
import Text.Blaze.Html.Renderer.String
import Text.Blaze.Html5 as H hiding (map, main)
import Text.Blaze.Html5.Attributes as A
import System.FilePath
--------------------------------------------------------------------------------

data Page = Home | Organisation | News | Events | Supervisors | Zulip
    deriving (Eq)

type URL = String
type Children = [(String, URL)]
type MenuEntry = (Page, URL, Children)
type EventInfo = (String, URL)

instance Show Page where
    show Home = "Home"
    show Organisation = "Organisation"
    show News = "News"
    show Events = "Events"
    show Supervisors = "PhD Opportunities"
    show Zulip = "Zulip"

data SupervisorData = MkSupervisor {
        supName :: String,
        supSiteUrl :: Maybe String,
        supPicUrl :: String,
        supInterests :: String
    }

institutions :: [(String, String)]
institutions = [("University of Edinburgh", "edinburgh"),
                ("University of Glasgow", "glasgow"),
                ("Heriot-Watt University", "heriot-watt"),
                ("University of St Andrews", "st-andrews"),
                ("University of Stirling", "stirling"),
                ("University of Strathclyde", "strathclyde"),
                ("University of the West of Scotland", "uws")]
--------------------------------------------------------------------------------

-- Matches a file in the given glob, then copies across
idMatch glob =
    match glob $ do
        route   idRoute
        compile copyFileCompiler


replaceExt :: Identifier -> String -> FilePath
replaceExt path ext = (takeFileName (toFilePath path)) -<.> ext

-- Compiles a markdown file and routes it to an HTML file
compileMarkdown glob pg =
    match glob $ do
        let dropExt path = (takeFileName (toFilePath path)) -<.> "html"
        route   (customRoute dropExt)
        compile $ do
            sCtx <- skeletonContext Organisation
            pandocCompiler
                >>= loadAndApplyTemplate "templates/content.html"  defaultContext
                >>= loadAndApplyTemplate "templates/skeleton.html" sCtx
                >>= relativizeUrls

main :: IO ()
main = hakyll $ do

    -- Assets
    idMatch "assets/img/*"
    idMatch "assets/img/**/*"
    idMatch "assets/css/*"
    idMatch "assets/js/*"
    idMatch "assets/vendor/**/*"

    -- Templates
    match "templates/*" $ compile templateBodyCompiler

    -- Events
    match "content/events/regular/*.md" $ compile pandocCompiler
    match "content/events/seminars/*.md" $ compile pandocCompiler
    compileMarkdown "content/events/spli/*.md" Events
    -- (also need to re-load events for the navbar)
    match "content/events/spli/*.md" $ version "navItems" $ compile pandocCompiler

    -- News items
    -- TODO: Blog items pages
     -- match "content/news/*.md" $ do
    match "content/news/*.md" $ compile pandocCompiler
        
    -- News main page
    -- TODO: PAGINATION
    create ["news.html"] $ do
        route idRoute
        compile $ do
            sCtx <- skeletonContext News
            newsItems <- recentFirst =<< loadAll "content/news/*.md" :: Compiler [Item String] 

            let itemContext = field "content-short" (\itm -> return "TODO: CONTENT SHORT")
                                <> field "long-url" (\itm -> return "TODO: LONG URL")
                                <> field "datetime-human" (\itm -> return "TODO: DATETIME HUMAN RENDER")
                --
            let itemsContext = listField "posts" itemContext (return newsItems) <> defaultContext
            --
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" itemsContext
                >>= loadAndApplyTemplate "templates/skeleton.html" sCtx
                >>= relativizeUrls

    -- Main page
    match "content/about.md" $ do
        picsIdents <- getMatches "assets/img/hero-carousel/*"
        let mkPicItem ident = Item ident (toFilePath ident)
        let (pic1, pics) = maybe (mempty, [])
                (\(firstPic, rest) ->
                    ((constField "firstImage" (toFilePath firstPic)), (map mkPicItem rest)))
                (uncons picsIdents)
        let ctx = pic1
                    <> listField "images" (bodyField "url" <> aboutInfo <> defaultContext) (return pics)
                    <> aboutInfo
                    <> defaultContext
        route $ customRoute $ const "index.html"
        compile $ do
            sCtx <- skeletonContext Home
            pandocCompiler
                >>= loadAndApplyTemplate "templates/index.html" ctx
                >>= loadAndApplyTemplate "templates/skeleton.html" sCtx
                >>= relativizeUrls

    -- Content pages
    compileMarkdown "content/pages/organisation.md" Organisation
    match "content/studentships/**/*.md" $ compile pandocCompiler
    create ["events.html"] $ do
        route idRoute
        compile $ do
            sCtx <- skeletonContext Events
            regEvents  <- loadAll "content/events/regular/*.md"
            spliEvents <- loadAll ("content/events/spli/*.md" .&&. hasNoVersion)
            seminars   <- loadAll "content/events/seminars/*.md"

            let eventsCtx =
                    listField "regevents" defaultContext (return regEvents)
                    <> listField "splievents" defaultContext (return spliEvents)
                    <> listField "seminars" defaultContext (return seminars)
                    <> defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/events.html" eventsCtx
                >>= loadAndApplyTemplate "templates/skeleton.html" sCtx
                >>= relativizeUrls

    create ["supervisors.html"] $ do
        route idRoute
        compile $ do
            sCtx <- skeletonContext Supervisors
            institutionsHtml <- renderInstitutions
            let supervisorCtx = constField "institutions" (renderHtml institutionsHtml) <> defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/supervisors.html" supervisorCtx
                >>= loadAndApplyTemplate "templates/skeleton.html" sCtx
                >>= relativizeUrls

--------------------------------------------------------------------------------
-- Supervisors page

-- Renders the supervisors for a given institution
renderInstitution :: String -> [SupervisorData] -> Html
renderInstitution institution supervisors =
    div ! class_ "row gy-4" $ do
        h2 ! class_ "mt-5 mb-0" $ toHtml institution
        supervisorsHtml
    where
        supervisorsHtml = mapM_ renderSupervisor supervisors
        renderSupervisor sup =
            let supUrl = fromMaybe "#" (supSiteUrl sup) in
            let supBox = div ! class_ "team-member d-flex align-items-start" $ do
                    div ! class_ "pic" $ img ! src (stringValue (supPicUrl sup)) ! class_ "img-fluid"
                    div ! class_ "member-info" $ do
                        h4 $ a ! href (stringValue supUrl) ! class_ "stretched-link" $ toHtml (supName sup)
                        preEscapedToHtml (supInterests sup)
            in
            div ! class_ "col-lg-6" $ supBox

-- Loads all supervisors for an institution, returning name and supervisor details
loadInstitution :: (String, String) -> Compiler (String, [SupervisorData])
loadInstitution (name, path) = do
    supervisors <- loadAll $ fromGlob ("content/studentships/" ++ path ++ "/*")
    supervisorDetails <- mapM (\itm -> do
        let ident = itemIdentifier itm
        name <- getMetadataField' ident "title"
        pic <- getMetadataField ident "pic"
        url <- getMetadataField ident "url"
        let picUrl = fromMaybe "/assets/img/default-avatar.svg" pic
        return $ MkSupervisor name url picUrl (itemBody itm)) supervisors
    return (name, supervisorDetails)

-- Generates HTML for supervisor at each institution
renderInstitutions :: Compiler Html
renderInstitutions = do
    loadedInstitutions <- mapM loadInstitution institutions
    return $ div $ mapM_ (uncurry renderInstitution) loadedInstitutions

--------------------------------------------------------------------------------
-- Contexts
aboutInfo :: Context String
aboutInfo =
    constField "spli-header" "SPLI: The Scottish Programming Languages Institute"
    <> constField "spli-subheader" "The Scottish Programming Languages Institute (SPLI) co-ordinates community events that enhance programming languages research in Scotland."

defaultEvents :: [EventInfo]
defaultEvents = [("All events", "/events.html"), ("SPLS", "/spls"), ("SPLV", "/splv")]

menuItems :: [EventInfo] -> [(Page, String, Children)]
menuItems eventDetails = [(Home, "/", []), (News, "/news.html", []), (Organisation, "/organisation.html", []),
             (Events, "/events.html", eventDetails),
             (Supervisors, "/supervisors.html", []), (Zulip, "https://spls.zulipchat.com/", [])]

menuHTML :: [EventInfo] -> Page -> Html
menuHTML events activePage = H.ul entries
  where entries = mapM_ (\(pg, url, children) -> mkEntry pg (stringValue url) children) (menuItems events)
        renderChild (name, url) = H.li $ a ! href (stringValue url) $ toHtml name
        mkEntry pg url children = 
            let link contents = if activePage == pg then
                           a ! href url ! class_ "active" $ contents
                       else
                           a ! href url $ contents
            in
            if null children then
                H.li (link $ toHtml (show pg))
            else
                H.li ! class_ "dropdown" $ do
                    link $ do
                        H.span $ toHtml (show pg)
                        i ! class_ "bi bi-chevron-down toggle-dropdown" $ toHtml ("" :: String)
                    H.ul $ mapM_ renderChild children

skeletonContext :: Page -> Compiler (Context String)
skeletonContext currentPage = do
    spliEvents <- loadAll ("content/events/spli/*.md" .&&. hasVersion "navItems") :: Compiler [Item String]
    eventInfo <- mapM (\itm -> do
        let ident = itemIdentifier itm
        let url = replaceExt (itemIdentifier itm) "html"
        desc <- getMetadataField' ident "title"
        return (desc, url)) spliEvents
    let events = defaultEvents ++ eventInfo
    return $
        constField "menu" (renderHtml $ menuHTML events currentPage)
        <> defaultContext

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
