
import { Hero } from "@components/ui/common"
import { CourseList, CourseCard } from "@components/ui/course"
import { BaseLayout } from "@components/ui/layout"
import { getAllCourses } from "@content/courses/fetcher"
import Head from 'next/head'
export default function Home({courses}) {
  return (
    <>
    <Head>
    <meta property="og:image" content="/guia.png" />
    <meta name="description" content="Adquira a fração de NFT que mudará toda sua vida" />
    <link rel="icon" href="/favicon.ico" />
    </Head>
      <Hero />
      <CourseList
        courses={courses}
      >
      {course =>
        <CourseCard
          key={course.id}
          course={course}
        />
      }
      </CourseList>
    </>
  )
}

export function getStaticProps() {
  const { data } = getAllCourses()
  return {
    props: {
      courses: data
    }
  }
}

Home.Layout = BaseLayout
